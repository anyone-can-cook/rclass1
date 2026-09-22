## Problemset Title ----
## [ PROJ ] < Problem set 8 >
## [ FILE ] < lastname_firstname_problemset8.R >
## [ AUTH ] < Your name / GitHub handle >
## [ INIT ] < Date you started the file >

  # 38 points

## Overview ----

  # In this problem set, you will practice creating visualizations using the `ggplot2` library, 
  # including labeling axes, customizing colors, and making these plots presentation-ready. The data 
  # you will be working with is a California housing data set based on the 1990 Census, where each 
  # observation is a California district.

## Question 1: Explore data and create simple graphs ----
  # Load the following packages below: `tidyverse`, `ggplot2`, `scales`, and 
  # `RColorBrewer.` Note that `ggplot2` is part of `tidyverse`, and you do not need to load it separately, 
  # but we will do so for this problem set.

library(tidyverse)
library(ggplot2)
library(scales)
library(RColorBrewer)

  # Use load() and url() to load the housing_df dataframe from 
  # https://github.com/anyone-can-cook/rclass1/raw/master/data/housing/housing.RData.

  # This dataset was downloaded from Kaggle and contains data on California housing prices. Each 
  # observation in the dataset is a California district. Take some time to read about the data and 
  # the variables it contains. Kaggle California Housing Prices (https://www.kaggle.com/camnugent/
  # california-housing-prices).

rm(list=ls())
load(url('https://github.com/anyone-can-cook/rclass1/raw/master/data/housing/housing.RData'))

  # Q1.1 ----
  # 1 point
  # Let's investigate the housing_df dataframe. First, use head() and glimpse() to preview the 
  # data.

  # How many observations (rows) and variables (columns) are there?
  # Assign your answer as numbers to an object named `q1_1`.
  # Enter the nnumber of rows first and columns as the second element.

q1_1 <- 

  # Q1.2 ----
  # 1 point
  # 4. Use ggplot to create a simple scatterplot showing median_income on the x-axis and 
  # median_house_value on the y-axis. When your plot looks correct, assign the code 
  # to an object named `q1_2`.

q1_2 <- 

  # Q1.3 ----
  # 1 point
  # In the plot, you should notice there is a line of points spread out along y = 500000. If you 
  # inspect housing_df, you'll see there are many points with median_house_value of 500001, which 
  # suggests that observations containing median_house_value above 500000 may not be reliable.

  # Filter the dataframe to only contain observations with `median_house_value` of 500000 or less, 
  # and reassign this back to the `housing_df` dataframe. If you try running your code from 
  # question 1.2 again, you should see that the line of points is gone.

housing_df <- 

  # Q1.4 ----
  # 2 points
  # Next, take some time to investigate the `ocean_proximity` variable in the dataframe (e.g., 
  # variable type, class, descriptive stats like count). You may comment out these lines of code 
  # after you're done.

  # Then, copy your code from question 1.2 and update it so that points in the scatterplot have 
  # different colors for the values of ocean_proximity. 
  # Once your code works, assign it to an object named `q1_4`.

#typeof(housing_df$ocean_proximity)
#class(housing_df$ocean_proximity)
#housing_df %>%
#count(ocean_proximity)

q1_4 <- 

  # Q1.5 ----
  # 1 point
  # In the legend, you should notice that the categorical values for `ocean_proximity` are ordered 
  # alphabetically by default. This might not be the most logical ordering, as it would make more 
  # sense to arrange them by location.

  # Convert the `ocean_proximity` column into a factor with the levels in this order: 'ISLAND', 
  # 'NEAR BAY', 'NEAR OCEAN', '<1H OCEAN', 'INLAND'. Use the factor() function to specify the 
  # levels, and reassign it back to the original dataframe. 

  # If you try running your code from question 1.4 again, you should see the legend values in the 
  # updated order.

housing_df$ocean_proximity <- 

## Question 2: Colors in ggplot2 ----
  # Hue, Chroma, and Luminance are important color concepts, and are helpful specifically when 
  # working with colors in ggplot2.

  # Q2.1 ----
  # 3 points
  # Below we provide three character vectors with words to describe the concepts of Hue, Chroma, 
  # and Luminance, respectively. Some of the words can their concept correctly and _be described_ 
  # by the concept. Two words in each vector do not fit with the concept at all. 

hue <- c("blue", "red", "purity", "color", "tone", "light")
chroma <- c("intensity", "purity", "dark", "bright", "color", "black", "white")
luminance <- c("color", "intensity", "bright", "light", "dark", "tone")

  # Create three corresponding objects named `q2_hue`, `q2_chroma`, and `q2_luminance`
  # and assign them the correct values from `hue`, `chroma`, and `luminance` without the incorrect terms.

q2_hue <- 
q2_chroma <- 
q2_luminance <- 

  # The orange palette maintains the hue of orange. As orange is blended with white on the left side, 
  # the color becomes a lighter orange and lower in chroma. Similarly, as orange is mixed with black 
  # on the right side, the color becomes darker and lower in chroma. The luminance gets lower from 
  # left to right as the color goes from bright to dark.

display.brewer.pal(9,"Oranges")

  # Q2.2 ----
  # 1 point
  # Run the code below to graph the relationship between 
  # ocean_proximity and population by California district.

housing_df %>% 
  ggplot(aes(x = ocean_proximity, y = population, width = 0.8)) +
  geom_col()

  # Considering the bottom x-axis represents relative distance from the ocean;
  # what kind of variable is `ocean_proximity`? Answer in a single word, assign it to 
  # an object named `q2_2` (and don't forget to wrap the word in quotation marks).

q2_2 <- 

  # Q2.3 ----
  # 1 point
  # There are three color palette scales to choose from in the RColorBrewer library: 
  # sequential, qualitative, and diverging, best suited for representing different types of data 
  # (e.g., categorical, ordered). 
  # Add a color palette from RColorBrewer that is best suited for the data. Assign the code
  # to an object named `q2_3`. 

q2_3 <- 

  # Q2.4 ----
  # 1 point
  # Create the same plot as above in grayscale instead of color palettes. 
  # Assign the code to an object named `q2_4`. 

  # There are two functions for grayscale: one for continuous and one for categorical/ordinal level 
  # variables. Use the latter to fill the plot bars in greyscale. 
  # Also remember that it is generally a bad idea for dots, lines, or bars to be completely white, 
  # so make sure you choose appropriate values for the start = and end = argument values.

q2_4 <- 

## Question 3: Creating and customizing graphs ----
  
  # Q3.1 ----
  # 4 points
  # Building from Question 1.4, add the following to customize your plot.
  # Assign the plot code to an object named `q3_1`.

  # Use ggtitle() to give the plot a title
  # Use xlab() and ylab() to label the axes
  # Use scale_color_brewer() to set the color palette and legend title
  # Use scale_x_continuous() and scale_y_continuous(), along with the label_number() function 
  # to customize the scale display so they display the dollars in hundreds of thousands
  # (e.g., $100K, $200K, etc.).
  # According to the variable descriptions, the median income is reported in tens of thousands -- 
  # make sure to display this accordingly within the label_number `scale=` argument.
  # Use theme_minimal() or a custom theme for further customization.

q3_1 <- 

  # Q3.2 ----
  # 2 points
  # Create a second graph, the same scatterplot as the previous question (3.1) showing `median_income` 
  # on the x-axis and `median_house_value` on the y-axis, but with separate subplots (i.e., small 
  # multiple) for each value of ocean_proximity. Make sure to remove the color aesthetic from the 
  # previous scatterplot.
  # Assign this plot to an object named `q3_2`. 

q3_2 <- 

  # Q3.3 ----
  # 3 points
  # Create a third graph, a scatterplot showing longitude on the x-axis and latitude on the 
  # y-axis, with the points colored by ocean_proximity. Make sure to include the following:

  # Plot title
  # Appropriate axis labels
  # Legend with an appropriate title and your choice of color palette
  # Use coord_fixed() to fix the coordinate scaling
  # Any other theme or style customization.
  # Assign your plot to an object named `q3_3`.

q3_3 <- 

  # Q3.4 ----
  # 3 points
  # Create a fourth graph, a scatterplot showing longitude on the x-axis and latitude on the 
  # y-axis, with the points colored by `median_house_value.` Make sure to include the following:

  # Plot title
  # Appropriate axis labels
  # Legend with an appropriate title, value labels, and your choice of color palette
  # (use scale_color_gradient() along with label_number()). 
  #   Reminder: By "appropriate value labels" we mean for you to also include house values 
  #   in the legend that read like dollar amounts in the hundreds of thousands.
  #   (e.g. $100K, $200K etc.)
  # Use coord_fixed() to fix the coordinate scaling
  # Any other theme or style customizations
  # Assign the plot to an object named `q3_4`.

q3_4 <- 

  # Q3.5 ----
  # 3 points
  # Create a barplot (with `geom_bar()`) showing the average house value by `ocean_proximity`, 
  # with each category of `ocean_proximity` along the x-axis and the average house value 
  # on the y-axis.

  # First you will need to group `housing_df` by ocean_proximity and calculate the 
  # average house value per group (use `summarise()` and name this new variable `avg_house_value`).
  # You can do this all with pipes or assign to a temporary df. 
  # Whatever you decide, use the new data to create the plot with the following requirements:

  # Plot title
  # Appropriate axis labels
  # Appropriate scale display on axis (e.g., $100K, $200K, etc.)
  # Any other theme or style customizations (e.g., bar width)
  # Assign the plot to an object named `q3_5`. 

q3_5 <- 

## Bonus Question (up to 10% extra credit) ----
  # Create a graph using any variables you'd like from the housing dataset. However, as you've 
  # done in the previous questions, this cannot be a scatterplot or barplot you have already done. 
  # Make sure to title and label the plot appropriately and customize it how you'd like. Add a 
  # color palette from Rcolorbrewer or curate your own color palette. Then, write some text 
  # describing your findings or observations.

## Create a GitHub issue ----
  # 2 points
  # Go to the class repository https://github.com/anyone-can-cook/rclass1_student_issues_f26/issues and create a new issue.
  # Refer to rclass1 student issues readme https://github.com/anyone-can-cook/rclass1_student_issues_f26/blob/main/README.md 
  # for instructions on how to post questions or reflections.
  # You are also required to respond to at least one issue posted by another student.
  
  # Create an object named `issue` below and assign it the URL to your new issue, as a character object.  
  # Make sure the URL is in quotes.
  
  issue <- 
  
  # Create an object named `reply` below and assign it the URL to your response to another issue, as a character object. 
  # Make sure the URL is in quotes.
  
  reply <- 
  
## Submit problem set on Canvas ----
  # Use this naming convention "lastname_firstname_ps#" for your R script (e.g. jaquette_ozan_problemset8.R).
