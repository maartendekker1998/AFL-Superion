# Superion

This repository is a fork of https://github.com/peng-hui/Superion, which in turn is a fork of the original Superion repository https://github.com/zhunki/Superion. Please refer to the readme files of these respective repositories for further information. This fork continues the work of peng-hui, fixing some issues in the automatic generation of ANTLR file and the compilation of AFL with the custom compiled TreeMutation library. The purpose of this repository is to leverage Superion to perform grammar aware coverage guided greybox fuzzing on applications which require input messages in a protocol format that is defined on top of XML.

## Build ANTLR runtime
To build Superion, we first need to build the ANTLR runtime. The ANTLR runtime is located in the tree_mutation folder.

```shell
cd /path/to/Superion/tree_mutation/
cmake ./
make
```
If a missing uuid error is raised, you need to install uuid first.
```shell
sudo apt-get install uuid-dev
```
## Generate lexer, parser, and visitors, given an ANTLR grammar

```shell
cd /path/to/Superion/tree_mutation/xml_parser/
make parser

```

## Compile the TreeMutation

To compile the treemutation for standalone testing (will generate a binary called main):
```shell
make compile
```

To compile the treemutation into the shared object `libTreeMutation.so` which is used in the compilation of AFL:
```shell
make share
```

## Compile AFL


```shell
cd /path/to/Superion/
make clean all

```