# Go, Introduction to an specialized Language

So, before we dive into the talk I want to inform you that most of the information presented in this talk is originated from the golang.org Project Page or some of the Code-Examples are written by me.

I must admit that i really enjoy writing code in go, but I have only used the language in private learning projects. But there are some major companies and projects that use Go as there productive main language, which you will see in Chapter **Sample Users**.

## Why Go
Go was first developed as an language to address sertan topics at google and brought to the open source community from an realy early state on. 

Some of this were explaned in [Go at Google: Language Design in the Service of Software Engineering](https://talks.golang.org/2012/splash.article) like:

- The problems introduced by multicore processors, networked systems, massive computation clusters, and the web programming model were being worked around (by the languages used at Google, like c++ java and python) rather than addressed head-on.
- server programs comprise tens of millions of lines of code, are worked on by hundreds or even thousands of programmers, and are updated literally every day.
- build times, even on large compilation clusters, have stretched to many minutes, even hours.

***Go was designed and developed to make working in this environment more productive***

Go was designed to address the problems faced in software development at Google, which led to a language that is not a breakthrough research language but is nonetheless an excellent tool for engineering large software projects.
The goals of the Go project were to eliminate the slowness and clumsiness of software development at Google, and thereby to make the process more productive and scalable. The language was designed by and for people who write—and read and debug and maintain—large software systems.

When Go launched, some claimed it was missing particular features or methodologies that were regarded as de rigueur for a modern language. How could Go be worthwhile in the absence of these facilities? Our answer to that is that the properties Go does have to address the issues that make large-scale software development difficult. These issues include:

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

From: [Go at Google: Language Design in the Service of Software Engineering](https://talks.golang.org/2012/splash.article)

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

### Error handling

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

But garbage collection comes with a price; general overhead, latency and complexity of the implementation. Go tries to address this issues by giving the programmer tools to limit allocation by controlling the layout of data structures. One way to reduce the pressure on the collector is by making  interior pointer idiomatic. 

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

[Go at Google: Language Design in the Service of Software Engineering](https://talks.golang.org/2012/splash.article)

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
**gofmt** the Go source code formatter, is not part of the language but so broad used from the beginning that Go code can be considered to have a single style everyone is now familiar with.
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
        <td>Communication through channels</td>
        <td>Point-to-point communication</td>        
    </tr>
    <tr>
        <td>Processes as "anonymous"</td>
        <td>no anonymity</td>
    </tr>
</table>

more details on [Communicating Sequential Processes (CSP)](https://arild.github.io/csp-presentation/#1)

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
Go ships a straigt forwart unit-test toolset and package set, which ingerates writing unittests smoothly and natural in the development process. With yust small changes to the tests, they are easy extended to benmarks.
```go
import (
    "testing"
)

func TestCreateSortedHist(t *testing.T) {
    sl := SetupTestDataSh(t)
    fs := sl.Freqs()
    if fs[sl.size-2] >= fs[sl.size-1] {
        t.Fatal("Failed to sort List")
    }
}

func BenchmarkConnect(b *testing.B) {
    cfg := GetTestCfg()
    d, err := OpenStorage(cfg)
    if err != nil {
        b.Fatal(err)
    }
    defer d.Close()
    d.Serve()
    con := d.Connect()
    for i := 0; i < b.N; i++ {
        r := new(StorageRequest)
        con.RequestChannel <- *r
        <-con.ResponseChannel
    }
    CleanTestDb()
}
```
### Net
The net package implements the listener patter for a broad spectrum of use cases.
```go
    addr, err := net.ResolveTCPAddr("tcp6", "[::]:56784")
    if err != nil {
        t.Fatal(err)
    }
    ln, err := net.ListenTCP("tcp6", addr)
    defer ln.Close()
    if err != nil {
        t.Fatal(err)
    }
    go func() {
        con, err := ln.AcceptTCP()
        defer con.Close()
        if err != nil {
            t.Fatal(err)
        }
        con.Write([]byte("foo"))        
    }()

    client, err := net.DialTCP("tcp6", nil, addr)
    defer client.Close()

    if err != nil {
        t.Fatal(err)
    }
```
### IO
[io package](https://golang.org/pkg/io/)
>Package io provides basic interfaces to I/O primitives. Its primary job is to 
>wrap existing implementations of such primitives, such as those in package 
>os, into shared public interfaces that abstract the functionality, plus some 
>other related primitives.

**The reader interface**

```go
// Reader interface
    type Reader interface {
        Read(p []byte) (n int, err error)
    }
    r := strings.NewReader("some io.Reader stream to be read\n")
    shortBuf := make([]byte, 3)
    if _, err := io.ReadAtLeast(r, shortBuf, 4); err != nil {
        fmt.Println("error:", err)
    }
```

**The writer interface**

```go
    type Writer interface {
        Write(p []byte) (n int, err error)
    }

    r := strings.NewReader("some io.Reader stream to be read\n")

    var buf1, buf2 bytes.Buffer
    w := io.MultiWriter(&buf1, &buf2)

    if _, err := io.Copy(w, r); err != nil {
        log.Fatal(err)
    }
```

### Encoding
[encoding package](https://golang.org/pkg/encoding/)
>Package encoding defines interfaces shared by other packages that convert 
>data to and from byte-level and textual representations. Packages that check 
>for these interfaces include encoding/gob, encoding/json, and encoding/xml. 
>As a result, implementing an interface once can make a type useful in 
>multiple encodings. 

```go
type TextMarshaler interface {
        MarshalText() (text []byte, err error)
}
type TextUnmarshaler interface {
        UnmarshalText(text []byte) error
}
```

And there are a cuple of packages implementing certen encodings, like:
<table>
    <thead>
        <td>package</td>
        <td>description</td>
    </thead>
    <tr>
        <td>asn1</td>
        <td>DER-encoding as defined in ITU-T Rec X.690</td>
    </tr>
    <tr>
        <td>base64</td>
        <td>encoding as specified by RFC 4648</td>
    </tr>
    <tr>
        <td>gob</td>
        <td>for binary exchange between an Encoder and a Decoder</td>
    </tr>
    <tr>
        <td>json</td>
        <td>JSON encoding as defined in RFC 7159</td>
    </tr>
    <tr>
        <td>pem</td>
        <td>PEM data encoding, originated in Privacy Enhanced Mail</td>
    </tr>
</table>

### Math
[math package](https://golang.org/pkg/math/)
> Package math provides basic constants and mathematical functions.

```go
    const (
            E   = 2.71828182845904523536028747135266249775724709369995957496696763 // https://oeis.org/A001113
            Pi  = 3.14159265358979323846264338327950288419716939937510582097494459 // https://oeis.org/A000796
            Phi = 1.61803398874989484820458683436563811772030917980576286213544862 // https://oeis.org/A001622

            Sqrt2   = 1.41421356237309504880168872420969807856967187537694807317667974 // https://oeis.org/A002193
            SqrtE   = 1.64872127070012814684865078781416357165377610071014801157507931 // https://oeis.org/A019774
            SqrtPi  = 1.77245385090551602729816748334114518279754945612238712821380779 // https://oeis.org/A002161
            SqrtPhi = 1.27201964951406896425242246173749149171560804184009624861664038 // https://oeis.org/A139339

            Ln2    = 0.693147180559945309417232121458176568075500134360255254120680009 // https://oeis.org/A002162
            Log2E  = 1 / Ln2
            Ln10   = 2.30258509299404568401799145468436420760110148862877297603332790 // https://oeis.org/A002392
            Log10E = 1 / Ln10
    )

    const (
            MaxFloat32             = 3.40282346638528859811704183484516925440e+38  // 2**127 * (2**24 - 1) / 2**23
            SmallestNonzeroFloat32 = 1.401298464324817070923729583289916131280e-45 // 1 / 2**(127 - 1 + 23)
            MaxFloat64             = 1.797693134862315708145274237317043567981e+308 // 2**1023 * (2**53 - 1) / 2**52
            SmallestNonzeroFloat64 = 4.940656458412465441765687928682213723651e-324 // 1 / 2**(1023 - 1 + 52)
    )

    const (
            MaxInt8   = 1<<7 - 1
            MinInt8   = -1 << 7
            MaxInt16  = 1<<15 - 1
            MinInt16  = -1 << 15
            MaxInt32  = 1<<31 - 1
            MinInt32  = -1 << 31
            MaxInt64  = 1<<63 - 1
            MinInt64  = -1 << 63
            MaxUint8  = 1<<8 - 1
            MaxUint16 = 1<<16 - 1
            MaxUint32 = 1<<32 - 1
            MaxUint64 = 1<<64 - 1
    )
```

**Subpackages**

<table>
    <thead>
        <td>package</td>
        <td>description</td>
    </thead>
    <tr>
        <td>big</td>
        <td>implements arbitrary-precision marithmetic</td>
    </tr>
    <tr>
        <td>bits</td>
        <td>bit counting and manipulation</td>
    </tr>
    <tr>
        <td>rand</td>
        <td>fast pseudo-random number generation (crypto/rand implements secure random number generatopn)</td>
    </tr>
</table>

#### Complex
[math/cmplx](https://golang.org/pkg/math/cmplx/)
> Package cmplx provides basic constants and mathematical functions for 
> complex numbers.

Example Polar returns absolute vale r and phase θ of x
```go
    r, theta := cmplx.Polar(2i)
    fmt.Printf("r: %.1f, θ: %.1f*π", r, theta/math.Pi)
```

### Reflection
[refelct package](https://golang.org/pkg/reflect/)
> Package reflect implements run-time reflection, allowing a program to 
> manipulate objects with arbitrary types. The typical use is to take a value 
> with static type interface{} and extract its dynamic type information by 
> calling TypeOf, which returns a Type.

```go
    type S struct {
        F0 string `alias:"field_0"`
        F1 string `alias:""`
        F2 string
    }

    s := S{}
    st := reflect.TypeOf(s)
    for i := 0; i < st.NumField(); i++ {
        field := st.Field(i)
        if alias, ok := field.Tag.Lookup("alias"); ok {
            if alias == "" {
                fmt.Println("(blank)")
            } else {
                fmt.Println(alias)
            }
        } else {
            fmt.Println("(not specified)")
        }
    }
```

## Future
In Gophercan 2017, Russ Cox, one of the language designer at google give us a brife overview how the language designers see the developing of the language.
You can read this for your self in [Toward Go 2](https://blog.golang.org/toward-go2) a text written for his talk.
I think the beside the new fetaurs Go 2 will provide it is important to know that they still stick to the same goal the langauge is originated in:

> We want to make programmers more effective at managing two kinds of scale: 
> production scale, especially concurrent systems interacting with many other 
> servers, exemplified today by cloud software; and development scale, 
> especially large codebases worked on by many engineers coordinating only 
> loosely,

Ross Cox addresses the reasoning as follwed:
> Our goal for Go 2 is to fix the most significant ways Go fails to scale.
 
which will be done under the self given constrain:
> The most important constraint is existing Go usage. [...] We must ask them 
> to unlearn old habits and learn new ones only when the reward is great. [...]
>  Go 2 must also bring along all the existing Go 1 source code. We must not 
>  split the Go ecosystem.

keeping this in ming means that bringing the language to the next step is not am end in itself. They collected and considered expirance reports collected since the anouncment of Go 2. [Report collection](https://github.com/golang/go/wiki/ExperienceReports)

But what is currently know of the Go 2 Design process, basicly that check and handle will be intreduced to the language to make error handling less repetitious.

```go
// Actual Go Code
func CopyFile(src, dst string) error {
    r, err := os.Open(src)
    if err != nil {
        return err
    }
    defer r.Close()

    w, err := os.Create(dst)
    if err != nil {
        return err
    }
    defer w.Close()

    if _, err := io.Copy(w, r); err != nil {
        return err
    }
    if err := w.Close(); err != nil {
        return err
    }
}
// With Go 2
func main() {
    handle err {
        log.Fatal(err)
    }

    hex := check ioutil.ReadAll(os.Stdin)
    data := check parseHexdump(string(hex))
    os.Stdout.Write(data)
}

```

And an other topic, could be generics, but this is still in the design process.

```go
// without generics
func Uniq(in <- chan string) <- chan string {
    out := make(chan string)
    go func () {
        v : <- in
        out <- v
        for next := range in {
            if v != next {
                v = next
                out <- v
            }
        }
    }
}

// generic apraoch
contract Equal(t T) {
    t == t
}

func Uniq(type T Equal) (in <- chan T) <-chan T {
    out := make(chan T)
    go func () {
        v : <- in
        out <- v
        for next := range in {
            if v != next {
                v = next
                out <- v
            }
        }
    }   
}
```
## Sample Users
<table>
    <thead>
        <td>company / project</td>
        <td>country</td>
        <td>note</td>
    </thead>
    <tr>
        <td>atlassian</td>
        <td>Australia</td>
        <td></td>
    </tr>
    <tr>
        <td>be-mobile</td>
        <td>Belgium</td>
        <td></td>
    </tr>
    <tr>
        <td>Wilab</td>
        <td>Argentina</td>
        <td>Industial / Oil & Gas IoT platform</td>
    </tr>
    <tr>
        <td>kira</td>
        <td>Canada</td>
        <td>ml for contracts and documents</td>
    </tr>
    <tr>
        <td>koho</td>
        <td>Canada</td>
        <td>fin-tec</td>
    </tr>
    <tr>
        <td>algolia</td>
        <td>france</td>
        <td>search engine</td>
    </tr>
    <tr>
        <td>psa</td>
        <td>France</td>
        <td>Automobile</td>
    </tr>
    <tr>
        <td>deliveryhero / lieferheld</td>
        <td>Germany</td>
        <td>Lieferdienst vernetzung</td>
    </tr>
    <tr>
        <td>centrifuge</td>
        <td>Germany</td>
        <td>Financial supply chain managment</td>
    </tr>
    <tr>
        <td>zalando</td>
        <td>Germany</td>
        <td>online shop</td>
    </tr>
    <tr>
        <td>socialcops</td>
        <td>India</td>
        <td>Business intelligence platform</td>
    </tr>
    <tr>
        <td>ThoughtWorks</td>
        <td>India</td>
        <td>Software development company</td>
    </tr>
    <tr>
        <td>eyesight</td>
        <td>Israel</td>
        <td>edge-based computer vision ai</td>
    </tr>
    <tr>
        <td>iguazio</td>
        <td>Israel</td>
        <td>Data Science and Analytics PaaS</td>
    </tr>
    <tr>
        <td>mathematic.ai</td>
        <td>Israel</td>
        <td>Applied algorithmic R&D Service</td>
    </tr>
    <tr>
        <td>nikai inc.</td>
        <td>Japan</td>
        <td>stock exchange</td>
    </tr>
    <tr>
        <td>BBC</td>
        <td>United Kingdom</td>
        <td>broadcast channel</td>
    </tr>
    <tr>
        <td>Google</td>
        <td>United States</td>
        <td>Search engine</td>
    </tr>
    <tr>
        <td>booking.com</td>
        <td>Netherlands</td>
        <td>Hotel booking platform</td>
    </tr>
    <tr>
        <td>AT&T</td>
        <td>United States</td>
        <td>broadcast network</td>
    </tr>
    <tr>
        <td>Docker</td>
        <td>United States</td>
        <td>container software</td>
    </tr>
</table>

And far more!