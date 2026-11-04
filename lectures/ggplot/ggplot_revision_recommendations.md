# Recommended revisions for `ggplot.qmd`

Audit date: November 4, 2026

Lecture reviewed: `ggplot.qmd` (2,130 lines at the time of review)

## Scope and how to use this document

This is a **substantive and pedagogical review**, not another argument-naming pass. The lecture itself was not changed during this review.

- **Important** recommendations address factual accuracy, deprecated or superseded interfaces, code that produces an unintended result, concepts that are likely to confuse beginning students, reproducibility, or accessibility.
- **Secondary** recommendations would improve clarity, pacing, consistency, or maintainability but can wait.
- Instructor-written tips, cautions, comments, checks, and plain-language explanations should be retained unless they are inaccurate. In many places below, the recommendation is to move a useful tidbit into a collapsible note—not to delete it.
- The recommendations are organized to match the lecture's level-1 and level-2 sections. Level-3 subsections are included where that makes the later revision work easier.

Technical claims were checked against the locally installed course packages:

- `ggplot2` 4.0.3
- `dplyr` 1.2.1
- `scales` 1.4.0
- `haven` 2.5.5

## Changes completed after the audit

- **November 4, 2026:** Replaced the lecture's `recode()` calls with the course-standard `recode_values()` syntax. Because the original inputs were factors, the revised code explicitly recreates the factors and preserves their original values and level order.
- **November 4, 2026:** Removed the unnecessary hidden `recode_factor()` call for `f1sex`, which was already a factor with the intended `"Male"` and `"Female"` levels.
- **November 4, 2026:** Replaced the `$<- factor(...)` assignment for `f1race` with the course-standard data-frame workflow: `mutate()` with `factor(x = ..., levels = ...)` inside it. This uses the same factor-creation function taught in the attributes/class lecture rather than introducing another forcats function.

## What should be preserved

These are real strengths of the lecture and should remain part of the revision:

- The course convention of explicitly naming meaningful function arguments.
- The small comments and reminders written for students who are new to or anxious about coding.
- The package-installation reminder that distinguishes quoted package names in `install.packages()` from unquoted package names in `library()`.
- The use of collapsible details blocks to keep optional code and background available.
- The repeated practice of inspecting variables before plotting and checking results after recoding.
- The distinction between `geom_bar()` and `geom_col()`.
- The explanation of global versus layer-specific mappings.
- The comparison of count data with a resulting bar chart.
- The use of student tasks with hidden solutions.
- The named-vector example for manual colors.
- The existing warning that scale limits can affect the fitted smooth. This is an excellent tip; it should be expanded by adding `coord_cartesian()`.

## Lecture-wide recommendations

### Important

- Replace copied **full function signatures** with short teaching templates plus `?function_name` or a link to the current help page. Many copied signatures are already stale, and the additional arguments create unnecessary cognitive load. A teaching template should show only the arguments students are expected to use.
- Do not globally suppress all warnings and messages. Several messages in this lecture explain important behavior, including which smoothing method was selected and which observations were removed. Suppress only known, unhelpful output in specific chunks.
- Choose one preferred syntax for first exposure. Put equivalent alternatives under a short “another form you may encounter” note. This is particularly important for faceting, labels, exporting, and the placement of mappings.
- Reduce repeated full plotting pipelines. Create a clearly named base plot or prepared data object, then add one component at a time. This makes the layered grammar visible and reduces maintenance errors.
- Use plot titles and prose that describe **relationships**, not correlations or causal effects, unless a correlation was actually calculated or a causal design was used.
- Add a one-sentence survey-data caveat. The ELS examples are unweighted descriptive examples for learning syntax; students should not interpret them as population estimates without the appropriate survey design and weights.
- Make accessibility a recurring plotting rule rather than a single color tip: readable text, sufficient contrast, meaningful labels, alt text, and visual distinctions that do not rely on color alone.

### Secondary

- Add two to four learning objectives at the beginning and a short “minimum workflow” recap at the end: data → `ggplot()` → `aes()` → geom → labels/scales/theme → `ggsave()`.
- Standardize “data frame,” capitalization, quote style, spaces after commas, and line breaks when each section is revised. These should not take priority over substantive work.
- Where code and rendered output are both shown, consider one executable chunk with code folding instead of separate visible and hidden copies of the same code.
- Use a manageable plotting sample or transparency when a lesson does not require all 53,940 rows of `diamonds`.

---

## 1. Introduction — lecture level 1

### Important

- Consider opening with one small finished plot built from three ingredients—data, mappings, and a geom—before introducing the formal grammar. The later vocabulary will then attach to something students have already seen.
- Remove the lecture-wide `warning = FALSE` setting. Keep `message = FALSE` where package startup messages are merely noise, but allow pedagogically useful messages and warnings to appear.
- Update the resources to the current [R for Data Science visualization chapter](https://r4ds.hadley.nz/data-visualize.html), the current [ggplot2 book](https://ggplot2-book.org/), and official ggplot2 help pages. Replace plain-HTTP resources where possible.

### Secondary

- Loading `ggplot2` after `tidyverse` is harmless and the existing comment correctly identifies the redundancy. Either retain it as a teaching reminder or remove the second `library()` call; do not leave it looking accidental.
- The general installation reminder is useful. It could eventually live on a shared course setup page, but there is no urgency to remove it from this lecture.
- Add a short statement of what students should be able to do by the end of the lecture.

### 1.1 Datasets we will use — lecture level 2

#### Important

- Simplify and document the chain of ELS objects. The lecture currently uses `df_els_stu_allobs`, `df_els_stu_allobs_fac`, `els`, `els_v2`, and `els_parphd`. A small table with “object / what changed / why it exists” would prevent students from losing track, or the lecture could commit to one analysis-ready object after the initial comparison.
- Correct the reason for using the factor version. ggplot2 can treat both character and factor vectors as discrete variables. Factors are especially useful when the categories, labels, or display order need to be controlled; they are not universally required by ggplot2.
- Connect the conversion choices to the rule taught in the attributes/class lecture:

  - character or numeric categorical vector → `factor()`;
  - haven-labelled vector whose value labels should become categories → `haven::as_factor()`;
  - haven-labelled continuous measurement → deliberate numeric conversion after inspecting its labels and missing-value codes.

- **Completed November 4, 2026:** Removed the hidden `recode_factor()` call for `f1sex`. It was unnecessary because `f1sex` was already a factor with the intended levels.
- Make the survey missing-value logic explicit. The negative ELS values are dataset-specific codes such as missing, skip, or nonresponse; “all values below zero are missing” is not a general R rule. Inspect and recode the documented codes deliberately.
- Reconsider the use of `els_parphd` merely to reduce the number of observations. It retains only 1,121 of 16,197 students and describes a substantively unusual subgroup. Either use a reproducible sample for plotting speed or repeatedly state that these examples describe only students whose parents have an advanced degree.
- Decide whether missing/skip/nonresponse categories should remain visible categories or become `NA`. Explain the decision rather than allowing coded missingness to flow into plots implicitly.
- The lecture downloads an external `.RData` file during rendering. Keep a local course copy or document the dependency so a network or repository problem does not prevent the lecture from rendering before class.

#### Secondary

- Explain that `load()` creates the objects stored inside the file in the current environment; it does not return one data frame in the same way as many import functions.
- If continuous variables are meant to become plain numeric vectors, prefer a deliberate conversion over `unclass()`. `unclass()` removes the haven class but retains label-related attributes, which is probably not the intended teaching point here.
- Keep the `glimpse()` and variable-label details; they are useful orientation aids.
- Add a short list of the analysis-ready variables created later: `hw_time`, `earn2011`, `totloan`, `ever_college`, and `ed_aspiration`.

### 1.2 Type/class of variables ggplot expects — lecture level 2

#### Important

- Replace the blanket claim that ggplot “doesn't work well” with haven-labelled variables. Behavior depends on the aesthetic and scale: some plots run but display underlying codes, while other mappings may select an inappropriate scale or fail. Intentional conversion makes the categories and labels unambiguous.
- Correct the sentence saying factors work best “because there is an ordering.” An ordinary factor is not necessarily ordinal. Factor levels define the set of categories and their display order; an **ordered factor** additionally represents an ordinal variable.
- Explain why the two haven-labelled examples behave differently. The bar chart may run while displaying stored numeric codes; mapping a labelled numeric vector to color can fail to produce the intended discrete scale. This contrast is more useful than a general “works/does not work” rule.
- Avoid overwriting `df_els_stu_allobs_fac$f1race` in place. Create a new object or a new variable so later output does not depend on whether this chunk was run.
- Warn that `factor(x = ..., levels = ...)` turns any omitted or misspelled value into `NA`. Follow the long, manually entered level list with a before/after `count()` or missing-value check.
- State precisely that factor level order controls the order of categories on discrete axes, in legends, and in facets.
- When the intent is only to remove negative coded missings, do not use `> 0`: that also drops legitimate zero values. In the current ELS data, `bys34a == 0` for 1,015 students. Use the cleaned `hw_time` variable or explicitly retain zero.

#### Secondary

- Consider a categorical variable with shorter labels for the first factor-order example; the long race/ethnicity labels compete with the class lesson.
- If `f1race` is already a factor and the lesson is only ordering, retaining `factor()` is reasonable because students already know it. A separate reordering function is not necessary unless it reduces complexity elsewhere.
- Use transparency or a sample in the full-data scatterplot so that the class comparison is visually legible.

---

## 2. Concepts — lecture level 1

### Important

- Correct the definition of an **aesthetic**. Points, lines, and bars are geoms; axes are produced through scales and guides. Aesthetics are visual properties or positions such as `x`, `y`, `color`, `fill`, `size`, `shape`, and `linetype`.
- Teach three distinct ideas together:

  - a **mapping** connects a variable to an aesthetic, such as `aes(color = f1sex)`;
  - a **scale** translates the variable's values into displayed colors, positions, or sizes;
  - a **setting** gives every observation the same visual value, such as `geom_point(color = "blue")`.

- Replace “seven parameters” and “five layers” with “seven components in the simplified grammar used in this lecture.” Data, mapping, stat, geom, and position are components of a layer; coordinates and faceting affect the plot more broadly. Scales and themes are also important plot components and are introduced later.
- Show one small plot and identify each component before treating the components individually.

### Secondary

- Preserve the transparency-sheet analogy; it is accessible and memorable.
- Reduce the number of overlapping quoted definitions. One plain-language definition plus the analogy will be easier for beginners.
- Fix the subject–verb agreement in “The seven parameters ... consists of” if that sentence remains.

### 2.1 Dataset (**data**) — lecture level 2

#### Important

- Replace superseded `summarize_all()` with the `summarize(across(...))` syntax already taught in the course.
- Show the ELS value labels or documentation before recoding negative values. Explain that these particular negative values are survey missing codes; negative values can be valid in many other datasets.
- Clarify that the cleaning pipeline creates new analysis variables and does not change the original source variables unless the result is assigned back.
- **Completed November 4, 2026:** Replaced visible uses of `recode()` with the course's `recode_values()` approach and explicitly restored the intended factor level order.
- Reconsider or prominently caveat `els_parphd`, as described above. It should not look like a neutral speed optimization.
- Decide and state how “Missing,” “Skip,” and “Nonrespondent” are treated analytically.

#### Secondary

- Keep the post-recode checks. They are exactly the kind of beginner-friendly habit the lecture should model.
- Break the long recoding calls across more lines and align old and new values for easier visual comparison.
- Put the variable-inspection and recoding details in a collapsible “preparing the plotting data” block if the main plotting sequence becomes too long.

### 2.2 Set of aesthetic mappings (**mappings**) — lecture level 2

#### Important

- State explicitly that renaming columns to `x`, `y`, and `color` is only a conceptual illustration. Students do **not** need to rename their variables before plotting.
- Add the mapping-versus-setting comparison here and repeat it briefly when students first construct a plot:

  ```r
  geom_point(mapping = aes(color = f1sex)) # color varies by a variable
  geom_point(color = "blue")                # every point is blue
  ```

- Explain that a mapping does not itself select the final displayed colors or tick positions; the corresponding scale performs that translation.
- Replace filters such as `filter(bys34a > 0)` when the stated goal is to remove missing codes. They silently exclude the 1,015 students who reported zero homework hours. Use `!is.na(hw_time)` or otherwise retain valid zeroes.

#### Secondary

- Change “a different set of mapping” to “a different set of mappings.”
- Keep both the scatterplot and bar-chart examples; they usefully show that different geoms require different mappings.
- Reduce duplicated visible/hidden chunks if code folding can provide the same teaching experience.

### 2.3 Statistical transformation (**stat**) — lecture level 2

#### Important

- Explain that a stat performs a calculation for the plot; it does not modify the source data frame.
- Replace “we usually do not transform the data prior to plotting” with the more precise point that `geom_point()` uses `stat_identity()`, so the layer uses the supplied x and y values instead of calculating a grouped summary.
- Preview the durable bar-chart rule:

  - `geom_bar()` uses `stat_count()` to calculate counts from rows;
  - `geom_col()` uses y-values already calculated in a data frame.

- Correct the `bys34a > 0` filters here for the same reason described above.

#### Secondary

- Retain the raw-data table and the resulting count table; they make the stat concept concrete.
- Do not add `after_stat()` unless students actually need it later in the course.

### 2.4 Geometric objects (**geoms**) — lecture level 2

#### Important

- Replace the statement that a point geom can “only include” position, color, shape, and size. Teach that each geom has required and optional aesthetics and that the help page lists them. Examples are more maintainable than a supposedly complete list.
- Replace “bar chart versus pie chart” as the example of changing only the geom. A pie chart also changes coordinates. Point versus line is a cleaner geom comparison.
- Use “trend line” or “smoothing curve,” not “line of best fit,” unless the code explicitly fits a named regression model.

#### Secondary

- Condense the multiple quoted definitions to one plain-language definition and examples.
- Add a practical rule: choose a geom based on what one row represents, the variables being displayed, and the question the graph should answer.
- Retain the explanation that a plot can contain multiple geoms; it prepares students for layering.

### 2.5 Position adjustment (**position**) — lecture level 2

#### Important

- Broaden the definition. Position adjustments can jitter, dodge, stack, fill, or nudge geoms; they do more than prevent overlap.
- Do not present default jitter as the main solution for two continuous monetary variables. Jitter changes the displayed loan and earnings positions. Use transparency and smaller points first.
- If jitter is retained, explain that it adds artificial displacement and exact plotted positions should not be read literally. Use explicit, reproducible settings such as `position_jitter(width = ..., height = ..., seed = ...)`.
- Prefer a small example with at least one discrete or heavily rounded position. Current ggplot2 documentation specifically describes that as the setting where jitter is most useful.
- Replace causal-sounding phrases such as “loans on earnings” with “relationship between loans and earnings.”

#### Secondary

- Retain the point that multiple observations can occupy the same visible location; that is an important plotting insight.
- A compact comparison of `position = "identity"`, jitter, and dodge/stack could show why “position” is a general layer component, but only if it does not lengthen the introduction too much.

### 2.6 Coordinate system (**coord**) — lecture level 2

#### Important

- Replace `qplot()`, which is deprecated, with `ggplot()` and an ordinary geom.
- Do not teach `coord_flip()` as the preferred current method. It is superseded; swap the x and y mappings for a horizontal boxplot. Mention `coord_flip()` briefly only so students can recognize older code.
- Introduce `coord_cartesian()` as the practical coordinate example. It zooms the visible region without removing observations or changing a smoother, unlike scale limits or data filtering.
- **Completed November 4, 2026:** Updated the degree recode from `recode()` to `recode_values()` and explicitly preserved all original categories and the intended degree order.
- If observations are filtered before plotting, say that the analytic sample has changed; do not describe the result as merely zooming.
- `coord_polar()` is now superseded by `coord_radial()`. Given the perceptual problems of polar displays and the low payoff for this course, either omit this example, move it to an optional note, or use the successor while explicitly cautioning students.

#### Secondary

- `coord_fixed()` is valid but lower priority for these students. Keep it as an optional example or pair it with an application where equal physical units matter.
- Prefer `labs(title = ...)` over introducing `ggtitle()` here if `labs()` will be the course standard.
- Simplify the abstract claim about plots using “any number of coordinates”; the ggplot2 output students see is a two-dimensional display.

### 2.7 Faceting scheme (**facets**) — lecture level 2

#### Important

- Explain that each panel contains the subset defined by its facet value and that positional scales are fixed across panels by default. Fixed scales support direct cross-panel comparisons.
- Replace unexplained jitter with transparency or controlled jitter.
- Make the threshold filters explicit analytic restrictions. If the intent is only to change the viewing window, use `coord_cartesian()`.
- Use one preferred faceting syntax for first exposure and defer alternatives to the later faceting section.

#### Secondary

- A variable with fewer categories would create a clearer first faceting example than seven race/ethnicity panels.
- Keep the phrase “small multiples”; students will encounter it outside R.
- Briefly preview the rule that `facet_wrap()` is usually convenient for one faceting variable, whereas `facet_grid()` gives row and column variables structural meaning.

---

## 3. Creating graphs using `ggplot` — lecture level 1

### Important

- Make the central construction pattern visually prominent:

  ```r
  ggplot(data = df_name, mapping = aes(x = x_variable, y = y_variable)) +
    geom_name()
  ```

- Build one plot incrementally rather than restarting the full pipeline for every concept.
- Replace copied default signatures with focused teaching templates and the current help page.

### Secondary

- Use `ggplot2` consistently when referring to the package and `ggplot()` when referring to the function.
- Consider an end-of-section mini-task in which students identify data, mappings, and geom in existing code before writing a new plot.

### 3.1 `ggplot()` and `aes()` functions — lecture level 2

#### Important

- Add a direct mapping-versus-setting comparison at the point where students begin writing plots.
- State the inheritance rule plainly: data and mappings placed in `ggplot()` are inherited by later layers unless a layer supplies or overrides them; a mapping inside a geom applies only to that layer.
- Replace copied signatures with stable teaching templates. The goal is to teach the common call, not the entire API.

#### Secondary

- Move `typeof()`, `class()`, and `attributes()` inspection into a collapsible “connection to the attributes and class lecture.” It is a useful tidbit but interrupts the plot-building sequence.
- Use the full diamonds scatterplot deliberately as an overplotting example, or add transparency/sampling. Do not repeatedly render 53,940 opaque points without explaining the result.
- Remove duplicated commented-out plot calls that exactly repeat the following live call.

### 3.2 Adding geometric layers — lecture level 2

#### Important across the subsection

- Update or remove stale signatures and complete aesthetic lists. In current ggplot2:

  - `geom_smooth()` uses `method = NULL` and `formula = NULL`, includes `orientation`, and uses `linewidth` rather than the older line-size wording;
  - `geom_bar()` and `geom_col()` have signatures that differ from the copied versions;
  - full aesthetic lists can change and are better consulted in `?geom_name`.

- Allow selected messages and warnings to be visible. The automatically selected smooth and removed-row warnings are part of the lesson.

#### Scatterplots using `geom_point()` — lecture level 3

**Important**

- Correct the prose/code mismatch: the text describes `bys34a`, `f3ern2011`, and `els`, while the code uses `hw_time`, `earn2011`, and `els_parphd` or `els_v2`.
- Teach overplotting remedies explicitly: transparency, smaller points, a reproducible sample, or a binned display. Jitter should be reserved mainly for discrete or rounded positions.
- If jitter remains, set its width, height, and seed rather than using `position = "jitter"`, which changes both continuous coordinates differently across renders.

**Secondary**

- Keep both locations for `mapping = aes(...)`, but label them as global versus layer-specific mappings rather than merely interchangeable spellings.
- Correct “type race/ethnicity” to “race/ethnicity.”
- Retain the accepted-aesthetics tip, but direct students to the help page instead of maintaining a complete list.

#### Smoothed prediction lines using `geom_smooth()` — lecture level 3

**Important**

- Rename the subsection “Smoothed trend lines” or similar. A smoother estimates a trend or conditional mean; it is not a prediction interval for individual observations.
- Revise the opening claim. `geom_smooth()` summarizes a relationship; it does not solve overlapping points. Transparency, size, sampling, or binning address overplotting. A smooth can supplement or replace the visible points depending on the teaching goal.
- Explain that the default shaded region is a 95% confidence band around the fitted trend, not a range containing 95% of individual outcomes.
- Make the method deliberate:

  - use `method = "lm"` when the pedagogical goal is a linear trend;
  - if keeping the default, explain that current ggplot2 uses LOESS when the largest group has fewer than 1,000 observations and a GAM at 1,000 or more. The full ELS example therefore uses a GAM.

- Explain grouping: `group = f1sex` creates separate smooths but does not visually identify them; mapping `color` or `linetype` both separates and distinguishes the groups.
- Fix the same prose/data mismatch noted in the scatterplot subsection.

**Secondary**

- Preserve the homework-time summary, but move it into a collapsible “inspect the variable before plotting” note and say how it informs the chosen plot.
- Remove the trailing comma after the final `summarize()` expression and stale commented-out `as_factor()` variants.

#### Plotting multiple geom layers — lecture level 3

**Important**

- Add `coord_cartesian(xlim = ..., ylim = ...)` immediately after the `xlim()`/`ylim()` example and contrast the results:

  - scale limits remove out-of-range observations before statistical calculations;
  - coordinate limits perform a visual zoom while retaining the observations used by the smoother.

- If the goal is to compare sex groups, use consistent visible mappings across layers or explain why points use color while smooths use linetype.
- Create a named base plot and add one layer or coordinate change at a time.

**Secondary**

- Correct “smooted” to “smoothed.”
- Put separate `xlim()` and `ylim()` components on separate lines and add spaces after commas.

#### Bar charts using `geom_bar()` and `geom_col()` — lecture level 3

**Important**

- Replace “Bar charts are used to plot a single, discrete variable” with “Bar charts compare quantities across categories.”
- Make the decision rule memorable: **Should ggplot count the rows, or have I already calculated the bar heights?**

  - `geom_bar()` counts rows and generally needs a categorical x or y mapping;
  - `geom_col()` displays precomputed values and needs both a category and a value.

- Explain that bars should normally include a meaningful zero baseline because viewers compare bar lengths.
- If means or other summaries are shown with bars, note that bars alone hide distributions and uncertainty; social-science results may be clearer with points and intervals, boxplots, or raw observations.
- Replace the stale signatures and combined aesthetic list with the two common syntax templates.

**Secondary**

- Preserve the two-method comparison; it is one of the strongest teaching sequences in the lecture.
- Move repeated `str()`/attribute inspection into a collapsible note if the section becomes too long.
- Correct `e.g,.` and use “standard deviation” rather than “std.”
- Use `eval = FALSE` consistently rather than the shortcut `F`.

### 3.3 Small multiples using faceting — lecture level 2

#### Important

- Fix the repeated category typo. The recode creates:

  ```text
  Attend college, no Bachelor's
  ```

  but five later filters request:

  ```text
  Attend college, no Bachelors 
  ```

  The missing apostrophe and trailing space silently exclude all 14 students in the intended category.
- Create a single prepared object such as `els_facets` containing the shared filter and reuse it. The current long filter is repeated six times, which caused the category bug and makes later revisions risky.
- Hold the non-facet components constant while comparing faceting methods. Current examples sometimes change jitter at the same time as the facet specification.
- Reduce the two-variable example to perhaps three or four aspiration categories. A 2-by-8 grid creates tiny panels and hides the conceptual lesson.
- Teach one preferred syntax first:

  - `facet_wrap(facets = vars(variable))` or the course's chosen consistent form for one variable;
  - `facet_grid(rows = vars(row_variable), cols = vars(column_variable))` for a meaningful two-way grid.

  Put formula syntax in a “you may also encounter” note.
- Explain the layout difference precisely. `facet_grid()` preserves a row-by-column matrix and can show empty cells for absent combinations; `facet_wrap()` lays out observed panels in a flexible ribbon.
- Replace copied signatures with focused templates. The current signatures omit newer arguments, retain deprecated interfaces, and will continue to drift.
- Decide whether the income thresholds intentionally exclude cases or merely change the view. Use filtering for an analytic restriction and `coord_cartesian()` for visual zooming.

#### Secondary

- Prefer transparency/smaller points to default jitter for the two continuous income variables. If jitter remains, make it reproducible and controlled.
- Briefly explain that fixed scales aid between-panel comparison, whereas free scales can reveal within-panel patterns but make comparisons harder.
- Correct “faceted by if student ever enrolled” to “faceted by whether the student ever enrolled.”
- Use readable strip labels and adequate figure dimensions.

---

## 4. Customization — lecture level 1

### Important

- Create one named base plot and add labels, scales, colors, and themes to it one at a time. The repeated full diamonds pipeline makes it difficult for beginners to see what changed.
- Use transparency or a reproducible sample so repeated plots of all 53,940 diamonds do not become a slow wall of opaque points.
- Replace complete copied signatures throughout this section with focused templates.

### Secondary

- End with one polished plot that combines the section's decisions. This gives students a model without requiring every intermediate example to be polished.
- Add a small decision checklist: labels → scale formatting → palette appropriate to variable type → readable theme.

### 4.1 Labels — lecture level 2

#### Important

- Teach `labs()` as the primary interface. Current ggplot2 marks `ggtitle()`, `xlab()`, and `ylab()` as superseded. Retain them briefly as shortcuts students may encounter in older code.
- Replace “Correlation between diamond carat and price” with “Diamond price by carat weight” or “Relationship between diamond carat and price.” The plot does not calculate a correlation coefficient.
- Use one example that supplies human-readable axis and legend labels as well as a title. Consider a subtitle and a source caption.

#### Secondary

- Add `alt` as an optional accessibility example and/or use Quarto figure-alt text.
- Preserve the `waiver()` explanation as a “help-file vocabulary” tip; it does not need to drive the main workflow.
- The copied `labs()` signature is incomplete in current ggplot2. A teaching template avoids ongoing maintenance.

### 4.2 Scales — lecture level 2

#### Important

- Replace deprecated `trans` with `transform` if a transform argument is shown.
- Explain that label functions alter how values **appear**, not the stored values themselves. For example, a `K` suffix and `scale = 1e-3` do not divide the data in the data frame.
- Clarify that scale limits can remove observations and affect stats. Use `coord_cartesian()` for visual zooming without dropping observations.
- Update or replace the copied `label_number()` signature; its defaults and available arguments have changed.
- Describe `label_number()` as formatting numbers rather than “forcing decimal display.”

#### Secondary

- Keep the equivalence of `1e-3` and `.001`, but state it in a note instead of rendering the full plot twice.
- Briefly say that discrete axes use discrete scales so students do not infer that every axis uses `scale_x_continuous()` or `scale_y_continuous()`.
- `label_dollar()` could be an optional convenience tip, but the existing prefix/suffix explanation is useful and should remain.

### 4.3 Colors — lecture level 2

#### Important

- Reorganize the section around the decision students need to make:

  1. Is the variable nominal, ordered, or continuous?
  2. Does the geom use `color` or `fill`?
  3. Which palette type fits that variable?
  4. Will the result remain distinguishable for color-vision differences and in grayscale?

- Preserve the HCL background, but shorten it or place it in an optional conceptual block after the practical rule.
- Correct the color-theory material:

  - “Violent” should be “Violet.”
  - Hue and color are related but not interchangeable terms.
  - Traditional color-theory “value” and HCL luminance are related but not identical concepts.
  - Qualitative palettes use distinguishable hues with broadly comparable visual weight; their chroma and luminance are not necessarily equal.

- Fix the inline example `palette = Pastel2`; it must be `palette = "Pastel2"`.
- Make the variable/palette match explicit:

  - qualitative palette → unordered categories;
  - sequential palette → ordered or continuous values moving from low to high;
  - diverging palette → two directions around a substantively meaningful midpoint.

- Change the palette for `diamonds$color`. It is an ordered factor from D through J; a diverging `"Spectral"` palette incorrectly implies a meaningful neutral middle. Use a sequential palette or explain a different substantive rationale.
- For race/ethnicity, explicitly select a qualitative palette. The bare `scale_fill_brewer()` call defaults to a sequential type, which is not the intended message for a nominal variable.
- Add a compact accessibility rule: do not rely on color alone for essential distinctions. Combine color with shape, linetype, labels, or facets when appropriate.
- Introduce a viridis option for ordered or continuous data. Current ggplot2 documentation recommends it as an easy perceptually uniform and color-vision-friendly choice.
- Replace the white-to-purple gradient on a white panel; low-valued points can disappear into the background.
- Replace the remaining `summarize_all()` call with `summarize(across(...))`.
- Retain the named-vector manual-color lesson but use a palette with adequate contrast and a variable for which a manual nominal mapping makes sense. Beige on white, bright yellow, and rainbow-like combinations are hard to read.
- Correct the statement about specifying colors. Valid forms include color names, hex strings, or strings created by `rgb()`; an arbitrary number is not generally a color specification.
- Use one spelling—`color` or `colour`—consistently in instructional code, noting once that ggplot2 accepts both.
- Reconsider grayscale point plots that distinguish many groups only by gray shade. Add shape/facets/direct labels, or use a different example.
- Replace externally hosted images with local assets or, at minimum, current HTTPS URLs and meaningful alt text. The present images are fragile and inaccessible.

#### Secondary

- Add one plain rule: `color` usually controls points, lines, and outlines; `fill` controls the interiors of bars and other areas.
- Replace the full Brewer, gradient, and manual-scale signatures with small templates.
- Correct “continous” to “continuous” and repair the unfinished depth-percentage quotation.
- Replace “Many journals require grayscale” with “Some journals print figures in grayscale, and readers may also print them that way.”
- Reuse a stored base plot for the default, Brewer, reversed, gradient, and manual examples.

### 4.4 Themes — lecture level 2

#### Important

- Do not model 8-point general text and a 10-point title. Use a readable base size such as `theme_minimal(base_size = 12)` or larger for slides.
- State that themes change non-data display; they do not change the mapped variables, observations, or statistical calculations.
- Simplify the main custom-theme example to two or three common changes, such as base font size, legend position, and axis-label angle. Preserve the longer example in an optional details block.

#### Secondary

- For academic work, a comparison of `theme_minimal()`, `theme_classic()`, or `theme_bw()` may be more useful than emphasizing `theme_dark()`.
- Mention `theme_set()` only as an optional tip for applying one theme to later plots.
- If retaining `unit()`, consider `grid::unit()` so students know where it comes from.

---

## 5. Exporting plots — lecture level 1

### Important

- Teach `ggsave()` as the primary code-based method in a ggplot2 lecture. Move the graphics-device workflow (`pdf()`/`jpeg()` plus `dev.off()`) to an optional “another method you may encounter” note.
- Save a named plot explicitly so students know exactly which plot is written:

  ```r
  diamond_plot <- diamonds %>%
    ggplot(mapping = aes(x = carat, y = price)) +
    geom_point(alpha = 0.2)

  ggsave(
    filename = "figures/diamond_price.png",
    plot = diamond_plot,
    width = 7,
    height = 5,
    units = "in",
    dpi = 300
  )
  ```

- Explain width, height, units, and DPI. The current `jpeg(width = 350, height = 350)` uses pixels by default and is likely too low-resolution for many uses.
- Qualify the vector-versus-raster advice. Vector output scales well for text and lines, but a scatterplot with tens of thousands of points can create a very large, slow vector file. Raster output can be the better choice for dense plots.
- Recommend PDF/SVG for vector output and PNG/TIFF for raster output. JPEG is lossy and usually a poor default for charts containing text and sharp lines.
- Refer to Quarto or rendered documents rather than only R Markdown, because this lecture is a `.qmd` file.

### Secondary

- Explain that `ggsave()` infers the output format from the file extension.
- Note that DPI matters for raster output, not ordinary vector output.
- Recommend a relative project folder such as `figures/` and a descriptive filename instead of `Rplot`.

### 5.1 Exporting in RStudio — lecture level 2

#### Important

- Frame the Export button as useful for a quick one-off. Code-based export is reproducible and should be preferred for assignments, papers, and analyses that will be rerun.

#### Secondary

- Refer to the “Plots pane” rather than assuming it is always in the lower-right corner.
- Replace the externally hosted HTTP screenshot with a current local screenshot and meaningful alt text, or omit it if the prose is sufficient.

### 5.2 Exporting via R code — lecture level 2

#### Important

- Lead with `ggsave()` and a named plot object.
- Move `pdf()`/`jpeg()` plus `dev.off()` below it as a base-R device workflow students may encounter.
- If the device workflow remains, explain that stored ggplot objects sometimes need an explicit `print()` inside functions, loops, or other programming contexts.

#### Secondary

- Keep the useful warning that the open-device, plot, and close-device commands must be run together, but attach it specifically to that workflow; it is not a limitation of `ggsave()`.
- Correct “code chuck” to “code chunk.”

---

## 6. References — lecture level 1

### Important

- The heading is currently empty. Either populate it or remove the heading.
- Prefer stable, official sources for technical claims and use third-party sources only when they add a distinctive pedagogical explanation.
- Audit every external image and link for availability, HTTPS, and accessibility.

### Secondary

- Add the current [ggplot2 book](https://ggplot2-book.org/) and [R for Data Science visualization chapter](https://r4ds.hadley.nz/data-visualize.html) as student follow-up resources.
- Use descriptive link text rather than bare URLs or images with empty alt text.

## Lifecycle and API items to address

| Current lecture item | Current status | Recommended treatment |
| --- | --- | --- |
| `qplot()` | Deprecated | Replace with `ggplot()` plus an ordinary geom. |
| `coord_flip()` | Superseded | Swap x and y mappings; mention only for recognizing older code. |
| `coord_polar()` | Superseded by `coord_radial()` | Omit/move to optional material, or use the successor with a perceptual caution. |
| `ggtitle()`, `xlab()`, `ylab()` | Superseded | Teach `labs()`; mention shortcuts only as older/convenience forms. |
| `summarize_all()` | Superseded | Replace with `summarize(across(...))`. |
| `recode()` | Superseded | **Resolved November 4, 2026:** replaced with `recode_values()` and explicit factor ordering. |
| `recode_factor()` | Superseded; no direct one-for-one successor | **Resolved November 4, 2026:** removed the unnecessary call. |
| Scale argument `trans` | Deprecated name | Use `transform`. |
| `geom_smooth(method = "auto", formula = y ~ x)` in copied signature | Backward-compatible but stale | Show current defaults `method = NULL`, `formula = NULL`, or use a focused template. |
| Copied geom/facet/scale signatures | Several are stale | Replace with teaching templates and point students to `?function`. |

## Suggested order for the later section-by-section revision

1. Fix the silent faceting-category typo.
2. Fix the `bys34a > 0` filters that exclude valid zero values.
3. Clarify or replace the nonrepresentative `els_parphd` restriction.
4. Correct the factor/haven-labelled explanation.
5. Correct aesthetics, mappings, settings, scales, and “five layers” terminology.
6. Replace deprecated/superseded examples and stale signatures.
7. Correct the smoother explanation and add `coord_cartesian()`.
8. Simplify faceting to one primary syntax and one prepared data object.
9. Reorganize colors around variable type, palette type, and accessibility.
10. Replace the export workflow with `ggsave()` as the default.
11. Reduce repetition with prepared data objects and base plot objects.
12. Do the lower-priority wording, typo, link, image, and formatting pass.

## Official documentation used for verification

- [`qplot()` lifecycle](https://ggplot2.tidyverse.org/reference/qplot.html)
- [`coord_flip()` lifecycle](https://ggplot2.tidyverse.org/reference/coord_flip.html)
- [Polar coordinates](https://ggplot2.tidyverse.org/reference/coord_polar.html)
- [`geom_smooth()` behavior and defaults](https://ggplot2.tidyverse.org/reference/geom_smooth.html)
- [`geom_bar()` and `geom_col()`](https://ggplot2.tidyverse.org/reference/geom_bar.html)
- [`position_jitter()`](https://ggplot2.tidyverse.org/reference/position_jitter.html)
- [`coord_cartesian()` and visual zooming](https://ggplot2.tidyverse.org/reference/coord_cartesian.html)
- [`xlim()`/`ylim()` and data removal](https://ggplot2.tidyverse.org/reference/lims.html)
- [`facet_grid()`](https://ggplot2.tidyverse.org/reference/facet_grid.html)
- [Faceting FAQ](https://ggplot2.tidyverse.org/articles/faq-faceting.html)
- [`labs()` and label lifecycle](https://ggplot2.tidyverse.org/reference/labs.html)
- [Continuous position scales](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
- [`label_number()`](https://scales.r-lib.org/reference/label_number.html)
- [ColorBrewer scales](https://ggplot2.tidyverse.org/reference/scale_brewer.html)
- [Continuous color scales and color-vision guidance](https://ggplot2.tidyverse.org/reference/scale_colour_continuous.html)
- [Complete themes](https://ggplot2.tidyverse.org/reference/ggtheme.html)
- [`ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html)
- [`summarize_all()` lifecycle](https://dplyr.tidyverse.org/reference/summarise_all.html)
- [`recode()` and `recode_factor()` lifecycle](https://dplyr.tidyverse.org/reference/recode.html)
