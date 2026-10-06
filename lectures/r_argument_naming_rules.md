# R argument-naming rules for lecture revisions

Reference for revising `patterns_base_r.qmd` and similar introductory lectures.

## Purpose and scope

Students are new to both R and programming. Explicit argument names reinforce the pattern `function_name(argument_name = argument_value)` and connect examples to help documentation. These lectures render as HTML rather than PDF slides, so slide-width constraints no longer justify omitting names.

Apply this convention consistently to all student-visible R example code and solutions, including nested calls. Ignore non-visible setup chunks.

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

1. **Values supplied through `...`:** Do not invent argument names. Preserve existing intentional names, such as names assigned to vector or list elements; adding such names can change the object. Name genuine additional arguments when supplied.

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

3. **Inputs supplied by pipes:** Preserve pipes. Do not rewrite a pipe solely to expose the implicit input's argument name. Apply the rule to arguments explicitly written inside calls, subject to the other exceptions.

## Specific cases and limits

- Keep the unnamed form of `rm()`: in `rm(vec_x)`, `vec_x` is the object to remove, supplied through `...`, not a formal argument name. Do not change it to `rm(x = vec_x)`. Update the object reference if that object is renamed under the conventions below.
- Keep `sum(df_school$visits_by_100751)` and `table(df_event$event_type)` unchanged; their data inputs are supplied through `...`.
- Preserve replacement syntax, such as `names(vec_a) <- c("var1", "var2", "var3", "var4")`. Do not force argument names onto the replacement expression on the left.
- Do not expand function signatures or add unused optional arguments or defaults. For example, use `sort(x = vec_x)` when only the input was originally supplied.
- Preserve the code's behavior, meaningful existing object names, and intentional element names. Rename generic example objects according to the conventions below.

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

> For all student-visible R code and solutions, add the formal argument name to every explicitly supplied function argument that has a meaningful formal argument name. Apply this to nested calls as well. Do not name values supplied through `...`; do not alter operators or subsetting syntax; do not alter replacement-function syntax; do not add optional arguments that were previously omitted; and do not rewrite pipes merely to expose an implicit input argument. Ignore non-visible setup chunks.

> In syntax explanations, distinguish fixed argument names from descriptive placeholders such as `obj_name`, `vec_name`, and `df_name`. In runnable examples, rename generic objects using `vec_x`, `list_x`, and `df_x` and the corresponding letter sequence for distinct coexisting objects. Keep the same name when recreating or modifying an object; reuse names across independent examples when safe; preserve meaningful existing names. Update all related code and prose consistently without changing behavior, function argument names, or dataset column and element names. Clearly distinguish argument passing from assignment.
