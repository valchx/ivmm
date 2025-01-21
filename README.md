# SVM - Simple Version Manager (Name subject to change)

This is a library, framework or piece of code that will let you create a version manager for your project.
It is inspired by what nvm, bob and other tools do.

You only need to tell SVM where to get your release versions list, and how to download and build (if needed) your product.
SVM does the rest.

# Features needed
- [ ] List local
- [ ] List remote versions
- [ ] Install new versions
- [ ] Swap active version
- [ ] Remove versions

# Other things to do
- [ ] Validate version list syntax
- [ ] Loggings errors

# Optional features
- [ ] Detect needed version (eg. nvmrc, cargo.toml, zig.zon, build.zig.zon, pom.xml...)

# Structure
```
- ./
    - bin/ # Would only add this to $PATH
        - <active version> # TODO : Either symlink or copy. For portability, copy is most likely.
        - <manager>
    - versions/
        - <...versions>
    - scripts/
        - list-remote.sh
        - list-local.sh
        - set-active.sh
        - remove-version.sh
        - install-version.sh
```

# What it needs to be
- Simple to extend
- Portable

# What to write it in

## Shell script
### Pros
- Portable
- No build system
### Cons
- Slower
- Kinda not fun to write, maybe, idk

## Zig
### Pros
- I like it
- Fast
- I like it.
### Cons
- IDK

## Golang
### Pros
- I just learned it.
- Seems cool
- Modern ?

### Cons
- A bit less strict. But that's okay.
