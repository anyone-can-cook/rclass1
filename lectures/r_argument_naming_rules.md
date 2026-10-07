# R argument-naming rules for lecture revisions

Reference for revising `patterns_base_r.qmd`, `into_the_tidyverse.qmd`, and similar introductory lectures using base R and tidyverse functions.

## Purpose and scope

Students are new to both R and programming. Explicit argument names reinforce the pattern `function_name(argument_name = argument_value)` and connect examples to help documentation. These lectures render as HTML rather than PDF slides, so slide-width constraints no longer justify omitting names.

Apply this convention consistently to all student-visible R example code and solutions, including nested calls, inline code, syntax explanations, and visible commented alternatives. Code remains in scope when its output is hidden (`results="hide"`) or it is displayed without execution (`eval=FALSE`). Ignore non-visible setup chunks and material inside HTML comments. Preserve deliberately incorrect examples and clearly label their intended error; do not accidentally repair the behavior being demonstrated.

## Core rule

**Name every explicitly supplied argument that has a meaningful formal argument name. Do not add arguments that the call does not otherwise need.**

Use the function's actual argument names, including in nested calls:

```r
typeof(x = df_event)
str(object = df_event)
head(x = df_event, n = 5)
mean(x = df_event[["med_inc"]], na.rm = TRUE)
str(object = dim(x = df_event))
subset(x = df_event, subset = event_type == "public hs")

nrow(
  x = subset(
    x = df_school,
    subset = school_type == "public" & pct_hispanic >= 50
  )
)
```

Use the named form of `subset()` throughout, replacing the lecture's mixture of named and positional forms.

## Systematic exceptions

1. **Values and expressions supplied through `...`:** Do not invent argument names. Preserve existing intentional names, such as vector or list element names, column definitions, and recoding mappings; adding or removing such names can change the result. Name genuine documented options when supplied, including options forwarded to a method through `...` (see below).

   ```r
   c(1, 2, 3)
   list(1:3, "a", 4:6)
   sum(1, 2, NA)
   table(df_event$school_type_pri, useNA = "always")
   order(df_event$event_date, df_event$total_12, decreasing = TRUE)
   ```

2. **Operators and subsetting:** Preserve ordinary syntax, including `$`, `[`, `[[`, arithmetic, comparisons, and `%in%`. Do not rewrite them as named function calls.

   ```r
   df_event$zip
   df_event[1:5, ]
   df_event[["zip"]]
   vec_x > 3
   vec_x %in% vec_y
   vec_x + vec_y
   ```

3. **Inputs supplied by pipes:** Preserve the existing pipe operator and let the pipe supply its implicit input. Do not add a second data argument or introduce a placeholder solely to expose that input's argument name. Apply the rule to explicitly written arguments, including nested calls, using the argument positions after the pipe supplies its input. Preserve any existing purposeful placeholder or brace syntax.

## Specific cases and limits

- Keep the unnamed form of `rm()`: in `rm(vec_x)`, `vec_x` is the object to remove, supplied through `...`, not a formal argument name. Do not change it to `rm(x = vec_x)`. Update the object reference if that object is renamed under the conventions below.
- Keep `sum(df_school$visits_by_100751)` and `table(df_event$event_type)` unchanged; their data inputs are supplied through `...`.
- Preserve replacement syntax, such as `names(vec_a) <- c("var1", "var2", "var3", "var4")`. Do not force argument names onto the replacement expression on the left.
- Do not expand function signatures or add unused optional arguments or defaults. For example, use `sort(x = vec_x)` when only the input was originally supplied.
- Preserve the code's behavior, meaningful existing object names, and intentional element names. Rename generic example objects according to the conventions below.

## Tidyverse functions and expression syntax

### Use each function's actual data argument name

Do not assume all tidyverse functions use `.data`, or that all base R functions use `x`. Verify the documented function and relevant method for the package version used in the course. Use complete names rather than partial matching.

| Functions used in this lecture | Explicit input argument |
| --- | --- |
| `select()`, `filter()`, `arrange()`, `rename()`, `mutate()`, `summarize()` / `summarise()`, `group_by()` | `.data` |
| `count()`, `glimpse()`, `desc()`, `as_factor()` | `x` |
| `recode()` | `.x` |
| `if_else()` | `condition`, `true`, `false` |
| `starts_with()`, `contains()`, `ends_with()` | `match` |
| `ggplot()` | `data` for a data frame; `mapping` for `aes()` |

Examples (using lecture data):

```r
select(.data = df_event, instnm, starts_with(match = "event"))
filter(.data = df_school, school_type == "public", is.na(x = med_inc))
count(x = df_school, school_type)
arrange(.data = df_event, desc(x = event_date))

# The pipe supplies .data; the column expression is supplied through ...
df_school %>% filter(school_type == "public")

# The pipe supplies x to count()
df_school %>% count(school_type)

# Explicit arguments in nested helpers still receive their formal names
school_v2 %>%
  mutate(public = if_else(condition = school_type == "public", true = 1, false = 0))

# The pipe supplies data to ggplot(); aes() is the mapping argument
df_school %>%
  count(school_type) %>%
  ggplot(mapping = aes(x = school_type, y = n)) +
  geom_col()
```

The leading dot is part of `.data` and `.x`; do not remove it. Explain `.data = df_school` as passing the object `df_school` to a fixed argument named `.data`. This does not require rewriting column references using the separate `.data$column_name` notation.

### Preserve column expressions and meaningful names in `...`

- Leave unquoted column selections, filtering conditions, sorting expressions, and grouping variables unnamed when they were originally unnamed. For example, keep `school_type` in `select(.data = df_school, school_type)`; adding `x = school_type` would rename that column to `x`.
- Preserve names that intentionally create, overwrite, remove, or rename columns: `mutate(public = ...)`, `mutate(public = NULL)`, `summarize(avg_inc_zip = ...)`, and `rename(new_name = old_name)`. These names are chosen output column names, not fixed formal argument names. Do not apply the generic object naming convention to them.
- Preserve `recode()` mappings such as `"public" = 1`. The left side identifies an existing value, not a formal argument or an object to rename. Name the explicit input `.x`; keep documented options such as `.default` and `.missing` when already supplied.
- Preserve formulas, including the `condition ~ value` expressions in `case_when()` and `~ out_state` in `facet_wrap()`. Do not turn formulas into `=` expressions or invent names for the cases. Name the surrounding function's formal argument when appropriate, for example `facet_wrap(facets = ~ out_state)`.
- Keep dataset column names unquoted in the lecture's ordinary dplyr expressions, and keep character values quoted: `filter(.data = df_school, school_type == "public")`. Selection helper patterns are character strings, for example `contains(match = "inst_")`. Do not add quotes or `$` to bare column references as part of argument naming.

In prose, distinguish four roles: fixed formal argument names, data frame objects, column names, and literal values. Explain that `=` in `mutate(public = ...)` specifies a column in the returned data frame; `<-` saves that returned data frame to an object.

### Documented method arguments forwarded through `...`

The `...` exception means do not invent labels for variadic data or expressions. It does not prohibit naming a documented option merely because a generic forwards that option through `...`. Check the method appropriate to the example rather than relying only on the generic's formal arguments.

For example, `head()` has a generic input `x`, and its data frame method has a documented `n` argument:

```r
head(x = df_school, n = 10)
df_school %>% head(n = 10)
```

## Readability, behavior, and verification

- Break long nested calls across lines and indent them consistently. Keep the pipe operator at the end of a continued line in working examples. Do not change an intentionally broken line-break example that teaches this rule.
- Preserve existing meaningful object names, including `wwlist`, `wwlist_temp`, `school_v2`, and `school_sml`. A descriptive name does not need a `df_` prefix. A tibble is a data frame for the generic `df_x` naming convention.
- Do not add defaults or change data types, units, thresholds, missing-value handling, column names, column order, row order, grouping, or assignment behavior as part of a naming-only revision. Examples that explicitly teach an optional default should retain it.
- Keep function replacements and package modernization separate from argument naming. For example, flag the status of `recode()` for a teaching decision rather than automatically replacing it during this pass.
- Check that revised syntax explanations match the runnable code. Use named placeholders, for example `filter(.data = df_name, logical_condition)` and `if_else(condition = logical_condition, true = value_if_true, false = value_if_false)`. Identify these as templates, not runnable examples or complete function signatures.
- Verify representative named and unnamed calls produce equivalent results, especially piped and nested calls. Render the complete lecture in a fresh R session and inspect the HTML, including exercises, expandable solutions, and long code blocks. Check displayed but unexecuted examples separately. Preserve expected-error examples rather than evaluating them during rendering. Report any check that cannot be completed.
- Record pre-existing teaching or logic problems separately. For example, check whether code described as a percent produces a percent or a proportion, whether each pipe step accepts the preceding output, and whether a missing-value claim is specific to the displayed conditions or true of the function generally. Do not silently fold substantive corrections into a naming-only change.

Documentation references: [dplyr select](https://dplyr.tidyverse.org/reference/select.html), [dplyr count](https://dplyr.tidyverse.org/reference/count.html), [tidyselect helpers](https://tidyselect.r-lib.org/reference/starts_with.html), [magrittr pipes](https://magrittr.tidyverse.org/reference/pipe.html), and [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html). Confirm these against the installed course package versions when revising examples.

## Distinguish argument names, object names, and values

Keep the function's actual argument names. Make the distinction between those fixed names and the objects or values students supply clear in syntax explanations, runnable examples, and accompanying prose.

### Syntax explanations

Use `obj_name` as a placeholder when the supplied value is an object. Use `vec_name` or `df_name` when the explanation specifically requires a vector or data frame. Avoid templates such as `x = x` or `object = object`.

```r
length(x = obj_name)
str(object = obj_name)
dim(x = obj_name)
subset(x = df_name, subset = logical_condition)
```

For other inputs, use placeholders describing what belongs there, such as `number_of_rows` or `search_pattern`. Clearly identify syntax templates as templates, rather than runnable examples.

### Runnable examples: short names for generic objects

Use these conventions when replacing generic example names:

| Object | Naming convention |
| --- | --- |
| Atomic vector | `vec_x`, `vec_y`, `vec_z`, then `vec_a`, `vec_b`, etc. if needed |
| List | `list_x`, `list_y`, `list_z`, then `list_a`, `list_b`, etc. if needed |
| Data frame | `df_x`, `df_y`, `df_z`, then `df_a`, `df_b`, etc. if needed |

- Keep the same name when recreating or modifying an object as an example develops. Repeated assignments to `x` should become repeated assignments to `vec_x` when it remains the example's vector.
- Use different names for distinct objects that need to coexist, for example when comparing or combining two vectors.
- Reuse names across independent examples; do not assign a unique name to every object creation throughout the lecture. Check that reuse does not overwrite an object needed later.
- Preserve meaningful existing names, such as `northeast_states`, `visit_counts`, `df_event`, and `df_school`. Existing names that already follow this convention, such as `list_x`, can stay.
- Avoid naming an object after a function used in the lesson: use `list_x` rather than `list` for a generic list.
- Choose prefixes according to the object's structure, not merely its current spelling. Follow its role and uses rather than applying a blind global replacement. Retain and explain naming or type changes that are themselves part of the lesson.

Recreating or modifying the same vector:

```r
vec_x <- c(1, 2, 3)
vec_x <- c(1, 2, 3, NA)
length(x = vec_x)
```

Using two distinct vectors together:

```r
vec_x <- c(1, 2, 3)
vec_y <- c(4, 5, 6)
length(x = vec_x)
length(x = vec_y)
```

### Consistency and explanation

When renaming an example object, update its creation and all references within the relevant scope, including nested calls, subsetting expressions, replacement expressions, exercises, solutions, comments, and explanatory text. Do not change function argument names, dataset column names, intentional element names, or unrelated objects with the same spelling. Avoid collisions with existing names and preserve behavior.

Distinguish assignment from argument passing:

```r
vec_x <- c(1, 2, 3)  # assign a value to an object
length(x = vec_x)     # pass that object to argument x
```

Describe `x = vec_x` inside this call as supplying an object to an argument, not as creating or assigning to an object named `x`. Review similar ambiguities between fixed R syntax, placeholders, and names students choose. If an unusual name or notation is itself the subject of instruction, retain it and explain its role.

## Mechanical revision instruction

> For all student-visible R code and solutions, add the formal argument name to every explicitly supplied function argument that has a meaningful formal argument name. Apply this to nested calls as well. Do not invent names for values or expressions supplied through `...`; preserve intentional column definitions, renaming and recoding mappings, and formulas; name documented options forwarded to the relevant method; do not alter operators or subsetting syntax; do not alter replacement-function syntax; do not add optional arguments that were previously omitted; and do not rewrite pipes merely to expose an implicit input argument or add a second data input. Use the actual argument names for each function, including `.data`, `x`, `.x`, and `condition` where appropriate. Keep displayed but unexecuted code and visible commented alternatives consistent, while preserving deliberately incorrect examples and their intended errors. Ignore non-visible setup chunks.

> In syntax explanations, distinguish fixed argument names from descriptive placeholders such as `obj_name`, `vec_name`, and `df_name`. In runnable examples, rename generic objects using `vec_x`, `list_x`, and `df_x` and the corresponding letter sequence for distinct coexisting objects. Keep the same name when recreating or modifying an object; reuse names across independent examples when safe; preserve meaningful existing names. Update all related code and prose consistently without changing behavior, function argument names, or dataset column and element names. Clearly distinguish argument passing from assignment.
