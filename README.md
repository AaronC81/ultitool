# Fabric8
Fabric8 is a **universal interface layer for compilers and tools**.

Every single command-line compiler uses a *slightly* different set of arguments,
switches, and configurations. You're busy writing code; the last thing you
want to do is trawl through Google or `man` for some obscure compiler's
switches.

That's where Fabric8 comes in. It unifies the interface for all your favourite
build tools. You'll quickly learn Fabric8's command-line interface, and then
you can use that for any command-line tool you fancy. 

Even better, you can easily write build configurations for your projects using
Fabric8, turning it into 
**the simplest, most intuitive build system you've ever used.** Just specify
which tools you'd like to use, configure them using Fabric8's unified interface,
and boom - you can **build, run and watch your project** easily.

## What's this for?

**Full build systems are great, but they're a faff to set up.** They're
also jarring for anybody who isn't used to that build system. On the other
end of the spectrum, **a homemade `build.bat` can be a nightmare to maintain**
and requires knowledge of every command-line tool you need to use.

Fabric8 sits perfectly in-between. **It's easy to set up and understand**,
and uses a **near-identical interface for every tool.** 

## What's it like to use?

> **Note:** Fabric8 is **nowhere near complete.** Most of these examples
> will not work at all.

Let's compile some TypeScript to JavaScript. First, we need the Fabric8 
tool for TypeScript. We can fetch new tools using Fabric8's package manager, 
`fb8pkg`.

```
$ fb8pkg install typescript
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

Great, now we need to use it. You can invoke tools using `fb8`. The default
interface for tools is:

```
$ fb8 <name> <in> <out>
```

So, suppose we want to compile all the TypeScript in `.\ts` into `.\js`:

```
$ fb8 typescript .\ts .\js
```

That's it! Of course, the options offered by Fabric8 go much deeper; you can
refer to the Fabric8 documentation for those.

Suppose we wanted to put together a build system using Fabric8. We can make a
*Fabric8file* in our project directory, which is YAML formatted.

In it, we can simply write:

```yaml
steps:
  typescript .\ts .\js
```

We can now invoke the script using `fb8`. By default, it will build the project,
but you can also choose to watch or run the project.

```
$ fb8
[OK  ] Tool typescript finished successfully.
[OK  ] Build completed successfully.

$ fb8 --watch
...
```

## What do tools look like?

They're written as Ruby scripts.

Here's an example of that TypeScript tool.

```ruby
# This function uses a DSL to list dependencies.
def dependencies
  npm_package "typescript>=2.0.0"
  command "typescript" do
    # Each dependency may have a block which checks whether the dependency is
    # working properly, in addition to Fabric8's verification.
    # This enables a consistent build environment.
    # This would check that 'typescript --version' returned something sensible.
  end
end

# This specifies how to build using this tool.
def build(opts)
  # 'opts' is an object of arguments and switches.
  # They would be translated and sanitised to TypeScript's switches here, and
  # then...

  invoke_command "typescript #{converted_opts}"
end

# Likewise for watching and running.
def watch(opts)
end
def run(opts)
end
```