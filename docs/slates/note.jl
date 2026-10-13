try; import KaimonSlate; catch; error("This is a Kaimon Slate notebook — running it as plain Julia needs the KaimonSlate runtime in this environment. Add it with `import Pkg; Pkg.add(\"KaimonSlate\")`, or open it in Kaimon Slate."); end; KaimonSlate.standalone!(@__MODULE__; dir=@__DIR__)

#%% md id=intro
@md"""
# LogicalOperators
"""

#%% code id=a38617
using LogicalOperators

#%% code id=8ee8ee
### `@logic` bitwise

#%% code id=a66ccf
@logic 3 & 10

#%% code id=c964ce
@logic 3 & 10 | 7

#%% code id=e555a4
### `@logic` short-circuiting booleans

#%% code id=50eb78
x = 3
@logic x > 1

#%% code id=b23b32
@logic x < 1 || x > 10 && x isa Int

# ╔═╡ Slate.config · per-notebook settings (Settings panel)
#   docid = a5060708-88bf-435b-86cd-903991fb732e
# ╚═╡
