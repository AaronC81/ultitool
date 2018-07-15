# UltiTool
UltiTool is a **universal interface layer for compilers and tools**, which can
also be used as a **superb minimalistic build system**.

As a quick example, suppose I have a project which involves TypeScript, SASS
and Jade. This is the *complete, entire* configuration needed to build and
watch the project using UltiTool, written inside a *utfile* in the
project root:

```yaml
tools:
  typescript: .\ts .\gen\js
  jade: .\jade .\gen\html
  sass: .\sass .\gen\css
```

All that's required to build or watch from this is `ut` or `ut --watch` in
the command line.

If another developer is missing any of these tools, UltiTool can install the 
tools for them, supporting a wide range of package managers.

## What's this?

Every single command-line compiler uses a *slightly* different set of arguments,
switches, and configurations. You're busy writing code; the last thing you
want to do is trawl through Google or `man` for some obscure compiler's
switches.

That's where UltiTool comes in. It unifies the interface for all your favourite
build tools. You'll quickly learn UltiTool's command-line interface, and then
you can use that for any command-line tool you fancy. 

Even better, you can easily write build configurations for your projects using
UltiTool, turning it into 
**the simplest, most intuitive build system you've ever used.** Just specify
which tools you'd like to use, configure them using UltiTool's unified 
interface, and boom - you can **build, run and watch your project** easily.

## When would I use this?

**Full build systems are great, but they're a faff to set up.** They're
also jarring for anybody who isn't used to that build system. On the other
end of the spectrum, **a homemade `build.bat` can be a nightmare to maintain**
and requires knowledge of every command-line tool you need to use.

UltiTool sits perfectly in-between. **It's easy to set up and understand**,
and uses a **near-identical interface for every tool.** 

It's perfect for small projects or side projects, where you'd rather spend time
coding than setting up heavy build systems, but still want an easy way to build
your project reproducably.

## What's it like to use?

> **Note:** UltiTool is **nowhere near complete.** Most of these examples
> will not work at all.

Let's compile some TypeScript to JavaScript. First, we need the UltiTool 
tool for TypeScript. We can fetch new tools using UltiTool's package manager, 
`utpkg`.

```
$ utpkg install typescript
[INFO] Looking for 'typescript'...
[OK  ] Found typescript@1.0.0. Fetching...
[OK  ] Fetched typescript@1.0.0.
[INFO] typescript@1.0.0 depends on:
         npm package: typescript>=2.0.0
         command: typescript
       Checking dependencies now...
[OK  ] All dependencies met. Installing...
[OK  ] All done. The typescript tool is ready to use!
```

Great, now we need to use it. You can invoke tools using `ut`. The default
interface for tools is:

```
$ ut <name> <in> <out>
```

So, suppose we want to compile all the TypeScript in `.\ts` into `.\js`:

```
$ ut typescript .\ts .\js
```

That's it! Of course, the options offered by UltiTool go much deeper; you can
refer to the UltiTool documentation for those.

Suppose we wanted to put together a build system using UltiTool. We can make a
*utfile* in our project directory, which is YAML formatted.

In it, we can simply write:

```yaml
tools:
  typescript: .\ts .\js
```

We can now invoke the script using `ut`. By default, it will build the project,
but you can also choose to watch or run the project.

```
$ ut
[OK  ] Tool typescript finished successfully.
[OK  ] Build completed successfully.

$ ut --watch
...
```

## What do tools look like?

They're written as Ruby scripts, though they also have a YAML metadata file.

Here's an example of a simple tool.

```yaml
name: Example
description: An example tool.
version: 1.0.0
options:
  text:
    flag: no
    default: Foo
```

```ruby
build do
  out :ok, "You said: #{option('text')}"
end
```