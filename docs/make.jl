using Documenter
using PreludeDicts

makedocs(
    sitename = "PreludeDicts",
    format = Documenter.HTML(),
    modules = [PreludeDicts]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
