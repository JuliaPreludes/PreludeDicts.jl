# PreludeDicts.jl

```@eval
using DocumentationOverview
using PreludeDicts
DocumentationOverview.table_md(
    PreludeDicts;
    include = api -> api.hasdoc && !(api.value isa Module),
)
```

```@docs
PreludeDicts.modify!
PreludeDicts.Delete
PreludeDicts.Keep
PreludeDicts.tryset!
PreludeDicts.trysetwith!
PreludeDicts.tryinsert!
```
