---
namespace: pantherx
description: "Plugin Development Guide for PantherX Online Account Service"
description-source: ""
categories:
 - type:
   - "Guide"
 - location:
   - "PantherX"
   - "Plugin"
language: "en"
---

_PantherX Online Account Service_  supports a _Plugin System_ to allow third-party
applications to add their Account Management integrated to it.

In this document we provide information and resources that needed for this purpose.

## Online Accounts Plugin System structure

Plugin System consist of a `PluginManager` class which dynamically loads registered
plugins from file system during application start and call them during
_Account Service Param Verification_ and _Account Service Authentication_ tasks.

<div class="mermaid">
sequenceDiagram
   participant APP as 3rd-party App
   participant ACT as Account Service
   participant PLG as Plugin
   participant SEC as Secret Service
   APP ->> ACT : RPC request
   ACT ->> ACT : search for plugin existance
   ACT ->> PLG : verify parameters
   PLG -->> ACT : verification result
   alt verified
      ACT ->> SEC : request for protected parameters
      SEC -->> ACT : received values for protected params
      ACT ->> PLG : authenticate
      PLG -->> ACT : authentication result
      alt authenticated
         ACT ->> SEC : save protected parameters
         SEC -->> ACT : parameter saved
         ACT -->> APP : Account Saved
      else not authenticated
         ACT -->> APP : Account Authentication Failed
      end
   else not verified
      ACT -->> APP : Account Verification failed
   end
</div>

## Plugin Definition

For now _Plugin System_ supports `C++` and `Python` based plugins, based on your
preferred language, you could continue reading about following sections:

- [Python Based Plugins](#python-based-plugins)
- [C++ Based Plugins](#c-based-plugins)

### Python Based Plugins

Each Python Plugin is actually just a python module that implements an interface
provided by _Plugin System_.

When `PluginManager` loads a python-based plugin, `PluginFramework` module will be
added dynamically. this module is implemented on _Account Service_ with a series
of _types_ and _interfaces_. so you need to load this module dynamically inside your
plugin definition to prevent error occurrence:

```python
import pkgutil
if pkgutil.find_loader('PluginFramework') is not None:
   PluginFramework = importlib.import_module('PluginFramework')
```

we will continue with describing `PluginFramework` types and interfaces:

#### 1. `PluginFramework.StrStrMap`

This type is equivalent to `std::map<std::string, std::string>` container in C++.
we use that to return string based dictionaries to parent application.

#### 2. `PluginFramework.StringList`

This type is equivalent to `std::vector<std::string>` container in C++.
we use that to return list of strings to parent application.

#### 3. `PluginFramework.Plugin`

`Plugin` is base class for module development. you need to inherit from it
in order to create your plugin. Each plugin has two abstract methods: `verify`
and `authenticate`.  

**Important:** your derived class should named as `Plugin` in order to allow
parent Plugin Loader to load it.

```python
class Plugin(PluginFramework.Plugin):

   # Plugin title that account service check to find plugins
   title = 'plugin-name'

   def __init__(self):
      # Plugin initiation logic goes here
      pass

   def verify(self, params):
      # your service parameter verification logic goes here
      pass

   def authenticate(self, params):
      # your service authentication logic goes here
      pass
```

#### 4. `PluginFramework.ServiceParam`

This `struct` represents a parsed service parameter, parameter relaed flags will
add to this class beside it's key and value:

```python
class ServiceParam:
   key           # String
   val           # String
   is_required   # Boolean
   is_protected  # Boolean
```

#### 5. `PluginFramework.ServiceParamList`

This type is equivalent to `std::vector<ServiceParam>` in C++. we use this struct
to return a list of `ServiceParam` items to Account service.

#### 6. `PluginFramework.VerifyResult`

This class contains parameters related to raw data verification results. it holds
verification status flag, parsed parameters and list of errors occured during
plugin verification:

```python
class VerifyResult:
   verified # Boolean
   params   # ServiceParamList
   errors   # StringList
```

#### 7. `PluginFramework.AuthResult`

This class contains parameters related to plugin authentication result. it holds
authentication status flag, generated tokens during authentication process and
list of occurred errors:

```python
class AuthResult:
   authenticated # Boolean
   tokens        # StrStrMap
   errors        # StringList
```

#### 8. `PluginFramework.Plugin.verify`

This method is used to verify raw key-value parameters provided. it receives a
`StrStrMap` as input parameters and return a  `VerifyResult` structure in response:

```python
def verify(self, params):
   result = PluginFramework.VerifyResult()
   result.errors.append('method not implemented.')  
   result.verified = False  
   return result
```

#### 9. `PluginFramework.Plugin.authenticate`

This method is used to for plugin authentication process. this method receives
a `ServiceParamList` struct as input and returns a `AuthResult` class as response.

```python
def authenticate(self, params):  
   result = PluginFramework.AuthResult()  
   result.authenticated = False  
   result.errors.append('method not implemented.')  
   return result
```

#### 10. `PluginFramework.Plugin.read`

Implementing this method, your plugin read it's parameters from it's defined custom
data-source instead of default _Account Configuration File_. `read` method receives
a _unique identifier_ previously generated by plugin, and should retrun a
`StrStrMap` of plugin parameters.

```python
def read(self, id):
   result = PluginFramework.StrStrMap()

   # Do whatever needs to fill 'result' here...

   return result
```

#### 11. `PluginFramework.Plugin.write`

Implementing this method, your plugin writes received parameters to a custom data-source,
and return a _unique identifier_ related to it's write operation. this _unique identifier_
later will use for plugin details read or remove.

```python
def write(self, vResult, aResult):
   # Write parameters to whatever data-source you want and generate a
   # Unique ID for it. this Id needs to be returned to parent application.
   id = ...
   return id
```

#### 12. `PluginFramework.Plugin.remove`

this method calls during account removal, so plugin should remove whatever it,
previously generates using this method.

```python
def remove(self, id):
   # perform plugin cleanup task here and return it's status
   return True
```

### C++ Based Plugins

Each _C++ Based Plugin_  is a `C++` class which is derived form `IPlugin` interface.
we need to export this class definition as a _Shared Object_.

additionally implementing the `read`, `write` and `remove` virtual methods allows
the plugin to perform custom read/write operations.

```cpp
class IPlugin {
public:
    explicit IPlugin() = default;

    explicit IPlugin(const string &title) : title(title) {}

    virtual ~IPlugin() = default;

    virtual VerifyResult verify(const StrStrMap &params) = 0;

    virtual AuthResult authenticate(const ServiceParamList &params) = 0;

    virtual StrStrMap read(const string &id);

    virtual string write(VerifyResult &vResult, AuthResult &aResult);

    virtual bool remove(const string &id);

public:
    string title;
};
```

we need to implement `constructor`, `verify` and `authenticate` methods in our plugins.
definition of these methods is same as their python equivalent definitions:

```cpp
explicit PluginClass() : IPlugin("plugin-name") {}

virtual VerifyResult verify(const StrStrMap &params);

virtual AuthResult authenticate(const ServiceParamList &params);
```

after implementing our plugin, we need to export it's reference:

```cpp
#include "plugin-class.h"

PluginClass *allocator() {
   return new PluginClass();
}

void deleter(PluginClass* ptr) {
   delete ptr;
}
```

now that your plugin implementation is done, you need to build your plugin as
a _Shared Library_.

### Plugin Definition Notes

#### Managing Protected Params

In order to load protected parameters automatically during account modification,
you need tho add them as `ServiceParam` with _Empty Value_ to list of `VerifyResult.params`.
in this way _Account Service_ request for value of these parameters from
_Secret Service_ before calling the `authenticate` method.

#### Plugins with custom data source

If you want to develop a plugin that is responsible for it's own configurations,
you need to implement `read`, `write` and `remove` methods in your plugin
definition. using this methods, your plugin handles your account configuration
management by itself.

## Plugin Registration

After creating your plugin, you need to register in order to be able to load by
_Online Accounts Service_. for this you need to add a custom phase after `install`
called `register-plugin` in your package definition. in this phase you should
register your plugin:

```scheme
(add-after 'install 'register-plugins
   (lambda* (#:key inputs outputs #:allow-other-keys)
      (let* ((out     (assoc-ref outputs "out"))
             (regpath (string-append out "/etc/px/accounts/plugins"))
             (regdata (string-append "plugin:\n"
                                     "  name: " ,name "\n"
                                     "  version:" ,version "\n"
                                     "  type: cpp\n" ; allowed values are:
                                                     ;   - "python"
                                                     ;   - "cpp"
                                     "  path:" out "/lib/lib" ,name ".so\n")))
         (mkdir-p regpath)
         (display cpptest-data)
         (with-output-to-file (string-append regpath "/" cpptest-name ".yaml")
            (lambda _ (format #t cpptest-data))))))
```
