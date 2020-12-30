---
namespace: guix-graph
description: "guix graph command provides a visual representation of packages and their dependencies."
description-source: "https://guix.gnu.org/manual/en/html_node/Invoking-guix-graph.html"
categories:
 - type:
   - "Application"
 - location:
   - "Software"
   - "Command-line"
   - "Package managers"
language: en
---

# Overview    

Sometimes we need to check the packages and their dependencies and this is diffcult to check manually. So the `guix graph` command can help us and provides a visual representation of DAG. By default, `guix graph` emits a DAG representation in the input format of [Graphviz](https://www.graphviz.org/), so its output can be passed directly to the `dot` command of Graphviz. 


```bash
guix graph options package
```


## Example    

For example, the following command generates a PDF file representing the package DAG for the GNU Core Utilities, showing its build-time dependencies: 


```bash
guix graph coreutils | dot -Tpdf > dag.pdf
```

The output looks like this: 

![coreutils-graph](/coreutils-graph.png)


Note that you should install `graphviz` package for running the `dot` command.

## References:    

* [Invoking guix graph](https://guix.gnu.org/manual/en/html_node/Invoking-guix-graph.html)