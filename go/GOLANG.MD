Nevertheless -> bessere formulierung finden
# Go, Introduction

So, before we dive into the talk I want to inform you that most of the information presented in this talk is originated from the golang.org Project Page or some of the Code-Examples are written by me.

Secondly I must admit that i really enjoy writing code in go, but I have only used the language in private learning projects. Nevertheless, there are some major companies and projects that use Go as there productive main language, which you will see in Chapter **Sample Users**.

## Why Go
...
- The problems introduced by multicore processors, networked systems, massive computation clusters, and the web programming model were being worked around (by the languages used at Google, like c++ java and python) rather than addressed head-on.
- server programs comprise tens of millions of lines of code, are worked on by hundreds or even thousands of programmers, and are updated literally every day.
- build times, even on large compilation clusters, have stretched to many minutes, even hours.

***Go was designed and developed to make working in this environment more productive***

Go was designed to address the problems faced in software development at Google, which led to a language that is not a breakthrough research language but is nonetheless an excellent tool for engineering large software projects.
The goals of the Go project were to eliminate the slowness and clumsiness of software development at Google, and thereby to make the process more productive and scalable. The language was designed by and for people who write—and read and debug and maintain—large software systems.

When Go launched, some claimed it was missing particular features or methodologies that were regarded as de rigueur for a modern language. How could Go be worthwhile in the absence of these facilities? Our answer to that is that the properties Go does have address the issues that make large-scale software development difficult. These issues include:

- slow builds
- uncontrolled dependencies
- each programmer using a different subset of the language
poor program understanding (code hard to read, poorly documented, and so on)
duplication of effort
- cost of updates
- version skew
- difficulty of writing automatic tools
- cross-language builds
Individual features of a language don't address these issues. A larger view of software engineering is required, and in the design of Go we tried to focus on solutions to these problems.

Go was therefore designed with clarity and tooling in mind, and has a clean syntax. Compared to other languages in the C family, its grammar is modest in size, with only 25 keywords (C99 has 37; C++11 has 84; the numbers continue to grow). More important, the grammar is regular and therefore easy to parse (mostly; there are a couple of quirks we might have fixed but didn't discover early enough). Unlike C and Java and especially C++, Go can be parsed without type information or a symbol table; there is no type-specific context. The grammar is easy to reason about and therefore tools are easy to write.

From: [1](https://talks.golang.org/2012/splash.article)

## Overview
Go was designed with some basic principles in mind, regarding the reasons the language came to existence. 
- Dependencies: Go was designed to work at scale, with large programs, with lots of dependencies, which large teams of programmers working on it
- Must be familiar, roughly C like. So new programmers get productive quickly.
- Must be modern, so make better use of multi-core computers and networking, with for example build in concurrency

### Build System
The main mechanism by which Go achieves fast build times is its dependency management. The compiler processes only one file when an import statement is ridden and writes an headerfile for it. No actual program code is processed. Parsing the dependency graph can therefore be far more efficient than in C / C++. Also the dependency graph contains no cycles, but more to that in the packages chapter. Measurements at Google of compiling a large program written in Go with the earlier version written in C++ found an 50 times better compilation for the Go version. But there is more to that in the article mentioned in the earlier chapter.

### Syntax
Clean c-like Syntax with modest in size grammar , with only 25 keywords (C99 has 37; C++11 has 84; the numbers continue to grow). Unlike C and Java and especially C++, Go can be parsed without type information or a symbol table; there is no type-specific context. The grammar is easy to reason about and therefore tools are easy to write.
But the declaration syntax is closer to Pascal than to C.
```go
    var fn func([]int) int
    type T struct { a, b int }
```

```go
    int (*fn)(int[]);
    struct T { int a, b; }
```

Go knows only call by name, which supports its clean and simple approach. Names in general are an important part of the language design, they are always local (beside from the once used for grammar) and only exported if they start with an uppercase letter.

### Syntax differences
Comparing the Go Syntax which C there are some small differences, like:
- no is no pointer arithmetic
- there are no implicit numeric conversions
- array bounds are always checked
- there are no type aliases (after type X int, X and int are distinct types not aliases)
- ++ and -- are statements not expressions
- assignment is not an expression
- it is legal (encouraged even) to take the address of a stack variable

mostly encouraged by robustness and some features take the language more far away from the traditional C-Style like:

- concurrency
- garbage collection
- interface types
- reflection
- type switches

everything design in service of software engineering perspective.

### OOP
Go takes an unusual approach to object-oriented programming, allowing methods on any type, not just classes, but without any form of type-based inheritance like subclassing. This means there is no type hierarchy. This was an intentional design choice. Although type hierarchies have been used to build much successful software, it is our opinion that the model has been overused and that it is worth taking a step back. Instead, Go has interfaces, more to that later. With them Go encourages composition over inheritance, using simple, often one-method interfaces to define trivial behaviors that serve as clean, comprehensible boundaries between components.

### Error hevandling

In service of software engineering go provides a different set of features to encourage explicit error handling. So go don't use try-catch-finally constructs because the designers believe that exceptions are to easy to ignore, so go forces programmers to think about error handling.
First multiple return values is the heart and backbone of go's error handling, like shown in the example:

```go
    f, err := os.Open(fileName)
    if err != nil {
        return err
    }
```
And for fatal errors go provides *panic* and *recover*.

### Garbage collection
For a systems language, garbage collection is a controversial feature, but for an concurrent object-oriented language it is almost essential to have automatic memory management because the ownership of a peace of memory can be tricky to follow as it is passed around in different path's of execution.

Nevertheless garbage collection comes with a price; general overhead, latency and complexity of the implementation. Go tries to address this issues by giving the programmer tools to limit allocation by controlling the layout of data structures. One way to reduce the pressure on the collector is by making  interior pointer idiomatic. 

Example:
```go
    type X struct {
        a, b, c int
        buf [256]byte
    }
```
In Go this structure is allocated in one block of memory, so no indirection is necessary.

## Packages
Go's package system combines the properties of libraries, namespaces and modules. Then the package name (as distinct from path) is used to qualify items from the package in the importing source file:
```go
    import "encoding/json"
    var dec = json.NewDecoder(reader)
```
It's important to recognize that package paths are unique, but there is no such requirement for package names.

The Go tool chain has buildin support for remote repositories
```bash
    $ go get github.com/4ad/doozer // Shell command to fetch package

    import "github.com/4ad/doozer" // Doozer client's import statement
```

Packages play an important role in go's support on dependency management. On compile and link time, it is checked if there are any circular dependencies to avoid issues for the incremental builds.

I think it is also worth to mention that go considers the entire path of a package to identify it, in the code only the name is used. therefore multiple packages with a name like *numbers* for example are supported but only one can be used.

An important role in package interactions play interfaces and the howl approach to object oriented programming.

## Interfaces

> We argue that this compositional style of system construction has been 
> neglected by the languages that push for design by type hierarchy. Type
> hierarchies result in brittle code. The hierarchy must be designed early, 
> often as the first step of designing the program, and early decisions can 
> be difficult to change once the program is written. As a consequence, the 
> model encourages early overdesign as the programmer tries to predict every 
> possible use the software might require, adding layers of type and 
> abstraction just in case. This is upside down. The way pieces of a system 
> interact should adapt as it grows, not be fixed at the dawn of time.
[1]: https://talks.golang.org/2012/splash.article

Go interfaces are the backbone of go's approach to object oriented programming, by only defining an set of methods as interface it is relatively easy to extend existing code. The interface satisfaction is statically checked at compile time and can therefore type save. 

Example:
```go
    type Writer interface {
        Write(p []byte) (n int, err error)
    }
```
Interface composition is a different style of programming, and people accustomed to type hierarchies need to adjust their thinking to do it well, but the result is an adaptability of design that is harder to achieve through type hierarchies.

## Tooling
Tools are an important part of software engineering. Go's syntax, package system, naming conventions and other features were designed to make tooling easy. One of the best known example of this tools is *gofmt*.
**gofmt** the Go source code formatter, is not part of the language but so broad used from the beginning that Go code can be considered to have s single style everyone is now familiar with.
An other important tool is **gofix**. It allows the language designers to make sweeping changes to the APIs and applying the changes to existing old code, even if it still works. Old APIs can be deprecated quickly and automatically so only one version of the API needs to be maintained. 
As an example how good this works, recently Go's protocol buffer implementation was changed and running *go fix* on google's entire code base updated to the new API, so only one version of this API has to be maintained.
Others are:
**go** managing program construction including package acquiring from remote
**gotest** the test and benchmark runner  
**godoc** for documentation extraction
**golint** to print styling mistakes
**delve** an go debugger
...
## Concurrency
Go embodies a variant of CSP with first-class channels. That is, given a C-like language, CSP can be added to the language in a mostly orthogonal way, providing extra expressive power without constraining the language's other uses.
### CSP
- Expressive concurrency based on message-passing
- Sequential processing
- Synchronous communication through channels
- Multiplexing of channels with alternation

<table>
    <thead>
        <td>CSP vs.</td>
        <td>Actor Model</td>
    </thead>
    <tr>
        <td>- Communication through channels
            - Processes as "anonymous"
        </td>
        <td>
            - Point-to-point communication
            - no anonymity
        </td>        
    </tr>
</table>

more details on [2](https://arild.github.io/csp-presentation/#1)

### Example
```go
package main

import "fmt"

func sum(s []int, c chan int) {
    sum := 0
    for _, v := range s {
        sum += v
    }
    c <- sum // send sum to c
}

func main() {
    s := []int{7, 2, 8, -9, 4, 0}

    c := make(chan int)
    go sum(s[:len(s)/2], c)
    go sum(s[len(s)/2:], c)
    x, y := <-c, <-c // receive from c

    fmt.Println(x, y, x+y)
}
```
## Std Packages
Supported through the go's rich tool environment, the language is shipped with an great collection of std packages in the general spirit of go, the focus to support software engineering. Beside the std packages there are a lot of open source and easy to use packages, most of them can be found on github.

### Testing and Benchmarking
Go 
### Net
### Encoding
### IO
### Math
### Reflection
## Future
## Sample Users
## Summary