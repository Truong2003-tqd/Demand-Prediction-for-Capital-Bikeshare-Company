# Declaration of Authorship
The report is an assignment of my course in RMIT, articulated by 3 collaborators. This report got the mark 75.5/100 from the marker. Please click this link to download the full report [Full Report][...]

1. **Xuan Truong (Project Leader):** In this project, I was reponsible for writing codes from **processing, wrangling and visualizing data, building predictive model, researching and ideating business solutions**.

2. **Minh and Chau:** They are responsible for articulating business background, scenarios and recommendations for the current problems.

## Version History
- **Version 12 — 2025-11-12:** Added and refined the section "Distinctive Demand Across Time of Day" contrasting leisure-centric casual usage with commuter-pattern registered usage, with highlighted modeling implications.
- **Version 13 — 2025-11-12:** Added and refined the section "Weekend and Holiday – Secondary Demand Driver" describing higher casual medians and flattened registered commute peaks with a midday lift, including peak-timing effects and modeling notes.
- **Version 14 — 2025-11-12:** Added and refined "Seasonal Demand of Each User" detailing seasonal distribution differences, winter suppression mechanisms, and modeling/operational implications.

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

The critical aspect of our user base is the dominance of **registered users**, who account for **81.17%** of total recorded trips. The two user types are primarily differentiated by their access method: **registered users** commit to a **long‑term plan** (annual or 30‑day memberships), whereas **casual users** pay for **short‑term day passes**.

Given that Capital Bikeshare was a **newly founded** company during the study period, this dominance indicates the **convenience** and early **product–market fit** of this bike‑rental solution. It also **projects potential growth** of the registered segment in the next year. Therefore, future business development should **center around this group**—both by **attracting casual users** into membership and by **retaining and engaging** existing registered users.

## Distinctive Demand Across Time of Day

**Casual users exhibit a leisure-centric schedule.** Demand is **muted during early morning**, begins to build **late in the morning**, and **peaks around Midday and the Afternoon leisure window**, reflecting weather/comfort-sensitive trip purposes (often social or recreational).

**Registered users follow a structured commuter rhythm.** Demand forms a **pronounced bimodal pattern** with a **Morning Peak (commuter hours)** and an **Afternoon / Early Evening Peak**, aligning with work start and end times and indicating habitual, purpose-driven usage.

**Interpretation.** These **distinct temporal signatures** underscore the importance of **hour-of-day features** (and potential **weekday × hour interactions**) in predictive modeling:
- Casual demand volatility concentrates in the midday–afternoon band, suggesting opportunity windows for promotional upsell to membership.
- Registered demand stability at commute peaks supports operational planning for **bike availability and redistribution** during those critical windows.

Overall, the divergence between leisure-oriented and commute-oriented temporal patterns reinforces the need for **segment-specific time-based forecasting strategies**.

## Correlation Between Time, Season, Weather, and Demand
**Temporal drivers dominate usage variability.** Hour-of-day exhibits a strong positive association with demand for both user segments (≈ **r = 0.50**), reflecting pronounced commuter peaks (morning and late afternoon for registered users) and leisure peaks (late morning to early evening for casual users).

**Day-of-week effects diverge by segment.** Casual user demand rises noticeably on weekends (**r ≈ 0.17**), while registered user demand slightly declines (**r ≈ –0.07**), indicating that registered usage is more workday‑centric whereas casual usage is more recreation‑oriented.

**Aggregate weather condition dampens demand under adverse states.** Progression from clear to mist, light precipitation, and heavy precipitation correlates with a **stepwise reduction in total rentals**, underscoring sensitivity to perceived ride comfort and safety.

**Underlying weather factors show intuitive elasticities.** Demand increases with **warmer temperatures** and **lower humidity**, with **casual users exhibiting slightly higher positive temperature coefficients** than registered users—suggesting discretionary riders respond more strongly to favorable outdoor conditions. Conversely, elevated humidity suppresses usage marginally more among casual users, reflecting comfort thresholds.

> Overall, the interaction of fine‑grained time features (hour, weekday/weekend) and granular weather variables (temperature, humidity, condition category) collectively explains a substantial share of demand variation and reinforces segmentation strategies tailored to commuter versus leisure behavior.

## Weekend and Holiday – Secondary Demand Driver

**Casual Users.** Demand medians on **weekends and holidays are markedly higher** than on ordinary working days, especially during the **Midday** and **Afternoon leisure window**, indicating a strong recreational and discretionary usage pattern when schedule constraints are relaxed.

**Registered Users.** In contrast, the characteristic **commuter peaks (Morning / Late Afternoon)** **depress on weekends and holidays**, while **Midday usage shows a relative lift**. This redistribution reflects a shift from routine work trips toward occasional midday errands or leisure rides. The holiday pattern mirrors the weekend structure, reinforcing the effect of non-working status on temporal demand reshaping.

**Peak Timing Shift.** Weekend and holiday status influence not only the **absolute level of demand** but also the **timing of peak hours** for each segment:
- Casual demand shifts upward into the Midday–Afternoon band.
- Registered demand flattens at traditional commute peaks and partially reallocates toward Midday.

> These dynamics highlight the importance of incorporating **weekend / holiday interaction terms with hour-of-day** (e.g., `is_weekend * hour`, `is_holiday * hour`) in predictive modeling and segmentation strategy to capture structural changes in temporal usage patterns.

## Seasonal Demand of Each User

**Casual users concentrate in warmer seasons.** Usage clusters in **Spring and Summer**, together accounting for roughly **≈ 70%** of casual rides, while **Winter drops sharply to ~20.93%**. This pattern reflects the discretionary, weather‑sensitive nature of leisure and tourism trips.

**Registered usage is more balanced across seasons.** The highest share occurs in **Summer (31.25%)**, followed by **Spring (26.76%)** and **Fall (26.64%)**, with **Winter** lowest—consistent with reduced ride comfort and shorter daylight.

> Shorter **daylight hours** and **lower temperatures** in Winter suppress cycling—most visibly for leisure behaviors—driving the lowest seasonal proportions for both segments. These findings underscore the importance of including **seasonality** in demand models and calibrating **capacity by season and segment.**
