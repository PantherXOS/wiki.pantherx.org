---
namespace: recutils
description: "GNU recutils is a set of tools and libraries to access human-editable, text-based databases called recfiles."
description-source: "https://www.gnu.org/software/recutils/"
categories:
 - type:
   - "Application"
 - location:
   - "Tools"
   - "Utils"
language: en
---

# Introduction
GNU `recutils` is a set of tools and libraries to access human-editable, text-based databases called `recfiles`. The data is stored as a sequence of records, each record containing an arbitrary number of named fields. Recfiles are human-readable, human-writable and still easy to parse and to manipulate automatically.

## `recfile` Format
**1.** _Fields_ : The key--value pairs which comprise the data.  

*  _Example_: `Name: hamzeh`   
*  The separator between the field name and the field value is a colon followed by a blank character (space and tabs, but not newlines)     
*  A field name is a sequence of alphanumeric characters plus underscores (_), starting with a letter or the character %. (regex: `[a-zA-Z%][a-zA-Z0-9_]*`)   
*  Field names are case-sensitive. Foo and foo are different field names.   

**2.** _Records_ : The main entities of a recfile.    

* _Example_:    

```
Name: hamzeh
Phone: 00989111111111
Email: h.nasajpour@pantherx.org
```

*  It is possible for several fields in a record to share the same name or/and the field value.   
*  A record cannot be empty, so the minimum size for a record is 1.   
*  The maximum number of fields for a record is only limited by the available physical resources.    
*  Records are separated by one or more blank lines.   

**3.** _Comments_ : Information for humans' benefit only.

*  Any line having an # (ASCII 0x23) character in the first column is a comment line.   
*  Unlike some file formats, comments in recfiles must be complete lines. You cannot start a comment in the middle of a line.   

**4.** _Record Description_ : Describing different types of records.
Certain properties of a set of records can be specified by preceding them with a record descriptor. A record descriptor is itself a record, and uses fields with some predefined names to store properties.

*  [`%rec`](https://www.gnu.org/software/recutils/manual/recutils.html#Record-Sets): The most basic property that can be specified for a set of records is their type. The special field name %rec is used for that purpose:    
*  [`%type`](https://www.gnu.org/software/recutils/manual/recutils.html#Naming-Record-Types)     
*  [`%doc`](https://www.gnu.org/software/recutils/manual/recutils.html#Documenting-Records) As well as a name, it is a good idea to provide a description of the record set. This is sometimes called the record set's documentation and is specified using the %doc field.     
*  [_Record Sets Properties_](https://www.gnu.org/software/recutils/manual/recutils.html#Record-Sets-Properties) Besides determining the type of record that follows in the stream, record descriptors can be used to describe other properties of those records. This can be done by using special fields, which have special names from a predefined set.     

### `recfile` Sample (`contacts.rec`):
*  A Contacts db file.
*  It has three fields.
*  `Name` and `Phone` field are mandatory and they can't be empty.
*  `Email` field is optional.

```
# -*- mode: rec -*-
%rec: Contact
%mandatory: Name Phone

Name: hamzeh
Phone: 00989111111111
Phone: 00989123456789
Email: h.nasajpour@pantherx.org

Name: hadi
Phone: 00989222222222

# End of contacts.rec
```

## `recutils` Commands
__1.__ `recinf` - reads the given rec files (or the data from standard input if no file is specified) and prints a summary of the record types contained in the input.

```bash
$ recinf contacts.rec
2 Contact
```

__2.__ `recfix` - check a recfile for errors:

```bash
$ recfix contacts.rec
```

__3.__ `recsel` - recsel reads the given rec files (or the data in the standard input if no file is specified) and prints out records (or part of records) based upon some criteria specified by the user.

```bash
$ recsel contacts.rec
Name: hamzeh
Phone: 00989111111111
Phone: 00989123456789
Email: h.nasajpour@pantherx.org

Name: hadi
Phone: 00989222222222

$ recsel -e "Name = 'hamzeh'" -P Phone contacts.rec
00989111111111
00989123456789

$ recsel -e "Name = 'hamzeh'" -P Email,Phone contacts.rec
h.nasajpour@pantherx.org
00989111111111
00989123456789
```

__4.__ `recins` - adds new records to a rec file or to rec data read from standard input.

```bash
$ recins -f Name -v Alex -f Phone -v 9898111222333 contacts.rec

$ recsel contacts.rec
Name: Alex
Phone: 9898111222333 

Name: hamzeh
Phone: 00989111111111
Phone: 00989123456789
Email: h.nasajpour@pantherx.org

Name: hadi
Phone: 00989222222222
```

__5.__ [more commands](https://www.gnu.org/software/recutils/manual/recutils.html#Invoking-the-Utilities)

## Reference:
https://www.gnu.org/software/recutils/manual/
