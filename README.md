# Declaration of Authorship
The report is an assignment of my course in RMIT, articulated by 3 collaborators. This report got the mark 75.5/100 from the marker. Please click this link to download the full report [Full Report][...]

1. **Xuan Truong (Project Leader):** In this project, I was reponsible for writing codes from **processing, wrangling and visualizing data, building predictive model, researching and ideating business solutions**.

2. **Minh and Chau:** They are responsible for articulating business background, scenarios and recommendations for the current problems.

#
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

## Business Background
Established in 2010, **Capital Bikeshare** provides extensive service in **Washington, D.C.**, accommodating both **registered commuters** and **casual users**. Driven by **rising sustainability initiatives**, urban policies that encourage **low-carbon transportation**, and **changes in mobility patterns**, these factors have led to a **heightened demand** for bike-share services—offering an opportunity for providers such as Capital Bikeshare to **expand in Washington, D.C.** However, these systems face operational challenges, including **uneven bike distribution during peak usage periods**, **seasonal demand fluctuations**, and **disruption from different weather conditions**.

## Project Objective
Capital Bikeshare serves two primary user segments: **registered users** and **casual users**, each exhibiting **distinct daily and monthly usage patterns**. This project aims to:
- **Identify and characterize usage behaviors** by user type across hours, days, and months.
- **Quantify the impact of weather conditions** (temperature, humidity, wind, and weather situation) on rental demand.
- **Develop a regression-based prediction model** to forecast **rental demand for specific periods within the year** (e.g., hour/day/month), enabling more informed resource allocation and operational decision-making.

## Data Preprocessing
Because of academic constraints, the dataset is treated as **cross-sectional rather than strictly time-series**, focusing on per-record attributes instead of temporal dependency modeling. The preprocessing workflow (implemented in R) emphasizes:
- **Feature transformation & normalization** (e.g., converting raw temperature, wind speed, humidity into normalized scales).
- **Data quality assurance**: detecting and addressing **data errors**, structural inconsistencies, and implausible values.
- **Outlier detection & handling**: visual diagnostics (e.g., **box plots of continuous variables**) to isolate extreme observations potentially driven by unusual weather or atypical usage spikes.
- **Semantic feature labeling**: mapping coded weather situations and calendar markers into interpretable categorical factors.
- **Segmentation readiness**: ensuring derived features support downstream comparison between **casual vs. registered usage patterns**.

Highlighted R scripts and documentation:
- Preprocessing script: (Not found in repository under the expected name; please add or rename) **Preprocessing.R**
- Data Preprocessing: [1. Preprocessing.R](https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/22437fd93d86521ad0271e773ad4bbc716c47399/1.%20Preprocessing.R)
  
- Outlier diagnostics: [2. Outlier Detection.R](https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/main/2.%20Outlier%20Detection.R) – generates **box plots of continuous variables** to surface distribution shape and extreme values.
- Detailed methodological justification (Word document): [Predictive Report for Capital Bikeshare Data.docx](https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/22437fd93d86521ad0271e773ad4bbc716c47399/Predictive%20Report%20for%20Capital%20Bikeshare%20Data.docx) 

# Insight Deep Dive
## User Insight

- Key insight: **Registered users account for 81.17%** of all recorded trips, indicating a strong reliance on the **registered user** base.
- Access model differences: **Registered users** subscribe to long‑term plans (annual or 30‑day memberships), while **casual users** purchase short‑term day passes.
- Interpretation for a newly founded service: The dominance of registered users signals the **convenience and product–market fit** of Capital Bikeshare’s offering and **projects further growth of the registered segment** in the following year.
- Strategic recommendations: **Center growth plans around the registered cohort** by (1) **retaining** existing members, and (2) **converting casual users** through targeted promotions, pricing, and lifecycle communications; while continuing to **attract casual users** as a feeder funnel to membership.