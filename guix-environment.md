---
## _guix environment_
The purpose of guix environment is to assist hackers in creating reproducible development environments without polluting their package profile.
*  The guix environment tool takes one or more packages, builds all of their inputs, and creates a shell environment to use them.
*  Unlike virtualenv from python, Guix doesn’t limit the usage of languages.
*  You told Guix what do you need, and Guix gives it to you. If the packages are previously downloaded or built in your device, Guix can reuse it, no need for duplication.
*  The created environment is a profile. After invoking the command, Guix creates a directory within /gnu/store with symbol links for those needed packages gathered. You can check the actual path of that directory with
```shell
$ echo $GUIX_ENVIORNMENT
```

### _Usages_
__1.__ downloading or building packages in environment
```shell
$ guix environment --ad-hoc python python-numpy
```
`--ad-hoc` argument means that you want `python` and `python-numpy` as immediate packages. Without this argument, Guix will give you the dependencies of `python` and `numpy` themselves, which are those packages needed for compiling python and numpy. You don’t want to compile them, rather, you want to use them for your project, hence the `--ad-hoc` argument.

__2.__ In the following example guix will remove all existing environment variables predefined in your shell. Which means the new environment is pure. You won’t be able to access any existing commands in your system except for python3.
```shell
 $ guix environment --ad-hoc python python-numpy --pure
```

__3.__  You can write down your needed package in a file possibly named “foo-manifest.scm” like this one:
```scheme
	(specifications->manifest
		'("emacs" "python-numpy" "python" "python-flake8"))
```
```shell
$ guix environment --manifest ./foo-manifest.scm
```

__4.__  Create an environment for the package or list of packages that the code within file evaluates to.
```scheme
;;package.scm
(use-modules (guix)
             (gnu packages gdb)
             (gnu packages autotools)
             (gnu packages texinfo))

;; Augment the package definition of GDB with the build tools
;; needed when developing GDB (and which are not needed when
;; simply installing it.)
(package (inherit gdb)
  (native-inputs `(("autoconf" ,autoconf-2.64)
                   ("automake" ,automake)
                   ("texinfo" ,texinfo)
                   ,@(package-native-inputs gdb))))
```
```shell
$ guix environment -l package.scm
```

__5.__  Run command within an isolated container:   
guix will create a environment with changed root. Which means you won’t be able to see any files other than those within your working directory and its sub-directories.
```shell
$ guix environment --ad-hoc python python-numpy --container
```

### References:
* https://www.gnu.org/software/guix/manual/en/html_node/Invoking-guix-environment.html
* https://trivialfis.github.io/linux/2018/06/10/Using-guix-for-development.html#introduction
---