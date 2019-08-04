---
namespace: doxygen
description: "Doxygen is a documentation generator, a tool for writing software reference documentation. The documentation is written within code, and is thus relatively easy to keep up to date. Doxygen can cross reference documentation and code, so that the reader of a document can easily refer to the actual code."
description-source: "http://www.doxygen.nl/"
categories:
 - type:
   - "Tool"
 - location:
   - "Tools"
   - "Utils"
   - "Development"
   - "Documentation"
language: en
---

# Overview
Doxygen is a tool that can generate project documentation in HTML, PDF or Latex from code comments formatted with Doxygen markup syntax. The generated documentation makes easier to navigate and understand the code as it may contain all public functions, classes, namespaces, enumerations, side notes and code examples.

## Supported Languages
* C
* C++
* Fortran
* Objective-C
* C#
* PHP
* Python
* IDL (Corba, MIDL - Microsft Interface Definition Language)
* VHDL
* Tcl

## Installation
```bash
$ guix package -i doxygen graphviz 
```
## How to use
### 1. Doxyfile Settings: 
This section provides suitable settings for the Doxygen configuration file Doxyfile generated with the command `$ doxygen -g` or with the application DoxyWizard. The _Project Name_, _Project Breif_, _Input Source_ and _Output Directory_ are some of the settings that should be defined in _Doxyfile_. Full description of _Doxyfile_ is [here](http://www.doxygen.nl/manual/config.html).

### 2. Using Doxygen commands/tags in source codes
After creating a _Doxyfile_ you should mark-up the source codes with doxygen commands/tags as comments. All commands in the documentation start with a backslash (\) or an at-sign (@). A full list of doxygen commands is [here](http://www.doxygen.nl/manual/commands.html) and there are some of popular commands:
#### General 
* `@brief`	Brief description of class or function (fits a single line)
* `@details`	Details about class or function
* `@author <AUTHOR NAME>`	Insert author-name

#### Function/Method Documentation
* `@param <PARAM> <DESCR>`	Function or method parameter description
* `@param[in] <PARAM> <DESCR>`	Input parameter (C-function)
* `@param[out] <PARAM> <DESCR>`	Output paramter of C-style function that returns multiple values
* `@param[in, out] <PARAM> <DESCR>`	Parameter used for both input and output in a C-style function.
* `@tparam <PARAM> <DESCR>`	Template type parameter
* `@trhow <EXCEP-DESCR>`	Specify exceptions that a function can throw
* `@pre <DESCR>`	Pre conditions
* `@post <DESCR>`	Post conditions
* `@return <DESCR>`	Description of return value or type.

#### Miscellaneous
* `@remark`	Additional side-notes
* `@note`	Insert additional note
* `@warning`	 
* `@see SomeClass::Method`	Reference to some class, method, or web site
* `@li`	Bullet point

#### 3. Generate the documentation
```bash
$ doxygen Doxyfile 
```

## Using Doxygen with CMake for C/C++ Projects
**1.** First of all, we assumed that the project has a file structure like this:

```
Project |
        ├ docs\Doxyfile
        ├ src\*
        └ CMakeLists.txt
```

**2.** Generate a _Doxyfile_ in `docs` folder with `$ doxygen -g` and edit the following items:

```
PROJECT_NAME           = "project name"
PROJECT_NUMBER         = "revision number"
PROJECT_BRIEF          = "project description"
OUTPUT_DIRECTORY       = @CMAKE_CURRENT_SOURCE_DIR@/docs/
INPUT                  = @CMAKE_CURRENT_SOURCE_DIR@/src/
EXTRACT_ALL            = YES
EXTRACT_PRIVATE        = NO # YES/NO : refer to http://www.doxygen.nl/manual/config.html#cfg_extract_private
EXTRACT_PACKAGE        = NO # YES/NO : refer to http://www.doxygen.nl/manual/config.html#cfg_extract_package
EXTRACT_STATIC         = NO # YES/NO : refer to http://www.doxygen.nl/manual/config.html#cfg_extract_static
EXTRACT_LOCAL_METHODS  = NO # YES/NO : refer to http://www.doxygen.nl/manual/config.html#cfg_extract_local_methods
EXTRACT_ANON_NSPACES   = NO # YES/NO : refer to http://www.doxygen.nl/manual/config.html#cfg_extract_anon_nspaces
```

**3.** Add the following lines in the `CMakeLists.txt`:

```cmake
[...]
# check if Doxygen is installed
find_package(Doxygen)
if (DOXYGEN_FOUND)
    # set input and output files
    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    # request to configure the file
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)
    message("Doxygen build started")

    # note the option ALL which allows to build the docs together with the application
    add_custom_target( doc_doxygen ALL
            COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating API documentation with Doxygen"
            VERBATIM )
else (DOXYGEN_FOUND)
    message("Doxygen need to be installed to generate the doxygen documentation")
endif (DOXYGEN_FOUND)
[...]
```

**4.** Build the project. After building the _html_ and _latex_ documents will be generated in the `project/docs/` folder.

```
Project |
        ├ docs
        |     ├ Doxyfile
        |     ├ html\...
        |     └ latex\...
        ├ src\*
        └ CMakeLists.txt
```

## References:
* [Doxygen Commands](http://www.doxygen.nl/manual/commands.html)
* [CPP / C++ Notes - Doxygen - Documentation Generator](https://caiorss.github.io/C-Cpp-Notes/Doxygen-documentation.html)
* [Quick setup to use Doxygen with CMake](https://vicrucann.github.io/tutorials/quick-cmake-doxygen/)
* [doxygen how-to](https://www-numi.fnal.gov/offline_software/srt_public_context/WebDocs/doxygen-howto.html)
* [Automatic Documentation of Python Code using Doxygen](https://engtech.wordpress.com/2007/03/20/automatic_documentation_python_doxygen/)