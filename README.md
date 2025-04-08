# Variable Table

## Variable Description Table

| Variable Name | Role | Type | Description | Units | Missing Values |
|----------|----------|----------|------------------------|----------|----------|
| `instant` | ID | Integer | Record index | – | No |
| `dteday` | Feature | Date | Date | – | No |
| `season` | Feature | Categorical | 1: Winter, 2: Spring, 3: Summer, 4: Fall | – | No |
| `yr` | Feature | Categorical | Year (0: 2011, 1: 2012) | – | No |
| `mnth` | Feature | Categorical | Month (1 to 12) | – | No |
| `hr` | Feature | Categorical | Hour (0 to 23) | – | No |
| `holiday` | Feature | Binary | Whether the day is a holiday (from [DC holiday schedule](http://dchr.dc.gov/page/holiday-schedule)) | – | No |
| `weekday` | Feature | Categorical | Day of the week | – | No |
| `workingday` | Feature | Binary | 1 if the day is neither weekend nor holiday, otherwise 0 | – | No |
| `weathersit` | Feature | Categorical | 1: Clear, Few clouds, Partly cloudy; 2: Mist/Cloudy; 3: Light Snow/Rain; 4: Heavy Rain/Snow | – | No |
| `temp` | Feature | Continuous | Normalized temperature in Celsius: (t - t_min)/(t_max - t_min), t_min = -8, t_max = +39 | °C | No |
| `atemp` | Feature | Continuous | Normalized feeling temperature in Celsius: (t - t_min)/(t_max - t_min), t_min = -16, t_max = +50 | °C | No |
| `hum` | Feature | Continuous | Normalized humidity (divided by 100) | – | No |
| `windspeed` | Feature | Continuous | Normalized wind speed (divided by 67) | – | No |
| `casual` | Other | Integer | Count of casual users | – | No |
| `registered` | Other | Integer | Count of registered users | – | No |
| `cnt` | Target | Integer | Count of total rental bikes including both casual and registered | – | No |

# Data pre-processing steps

-   View data - check the data manually\
-   Check duplication - 0 duplication\
-   Check missing value - 0 missing value\
-   Check variable types\
-   Decide which variables should be removed\
-   Format the number of decimal places (prefer 2 or 3)\
-   Convert categorical variables to factor variables\
-   Consider to create new groups for categorical observations such as grouping months into quarters\
-   Encode dummies variables\
-   Descriptive statistics (min, max, median, quartiles, unique values)\
-   Check data distribution by histogram, boxplot, scatter plot\
-   Check the skewness, outliers

# Handle outliers (for casual and register variables)

-   Check outliers by histogram, scatter plot, boxplot\
-   Firstly, check the erroneous data such as "13th month", check the percentage of erroneous values\
-   Remove if the size is too small (\<1-3%), otherwise impute them by winzorization, kNN, forward-filling, back-filling\
-   Prefer to use scatter plot to break the data grid into 4 groups, try to understand the odds\
-   Then use boxplot to understand outlier distribution as the whole data\
-   Then plot the boxplot by each category. For example, plot the boxplots of each month and look at the outliers.\
-   Extract outliers to analyze the profile of each\
-   Doing this will give more holistic view of the data, help understand why the outlier happen and make decision to keep or remove
