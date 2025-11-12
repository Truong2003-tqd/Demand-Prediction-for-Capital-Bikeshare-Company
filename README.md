# Declaration of Authorship
The report is an assignment of my course in RMIT, articulated by 3 collaborators. This report got the mark 75.5/100 from the marker.

1. **Xuan Truong (Project Leader):** In this project, I was reponsible for writing codes from **processing, wrangling and visualizing data, building predictive model, researching and ideating business solutions**.

2. **Minh and Chau:** They are responsible for articulating business background, scenarios and recommendations for the current problems.

# Data Dictionary

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

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232144.png" width="60%">
</p>

*Figure. Proportion of Casual vs. Registered Users*

The critical aspect of our user base is the dominance of **registered users**, who account for **81.17%** of total recorded trips. The two user types are primarily differentiated by their access method: **registered users** commit to a **long‑term plan** (annual or 30‑day memberships), whereas **casual users** pay for **short‑term day passes**.

Given that Capital Bikeshare was a **newly founded** company during the study period, this dominance indicates the **convenience** and early **product–market fit** of this bike‑rental solution. It also **projects potential growth** of the registered segment in the next year. Therefore, future business development should **center around this group**—both by **attracting casual users** into membership and by **retaining and engaging** existing registered users.

## Correlation Between Time, Season, Weather, and Demand

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232227.png" width="70%">
</p>

*Figure. Correlation Heatmap of Bike-Sharing Demand and Related Variables*

**Temporal drivers dominate usage variability.** Hour-of-day exhibits a strong positive association with demand for both user segments (≈ **r = 0.50**), reflecting pronounced commuter peaks (morning and late afternoon for registered users) and leisure peaks (late morning to early evening for casual users).

**Day-of-week effects diverge by segment.** Casual user demand rises noticeably on weekends (**r ≈ 0.17**), while registered user demand slightly declines (**r ≈ –0.07**), indicating that registered usage is more workday‑centric whereas casual usage is more recreation‑oriented.

**Aggregate weather condition dampens demand under adverse states.** Progression from clear to mist, light precipitation, and heavy precipitation correlates with a **stepwise reduction in total rentals**, underscoring sensitivity to perceived ride comfort and safety.

**Underlying weather factors show intuitive elasticities.** Demand increases with **warmer temperatures** and **lower humidity**, with **casual users exhibiting slightly higher positive temperature coefficients** than registered users—suggesting discretionary riders respond more strongly to favorable outdoor conditions. Conversely, elevated humidity suppresses usage marginally more among casual users, reflecting comfort thresholds.

> Overall, the interaction of fine‑grained time features (hour, weekday/weekend) and granular weather variables (temperature, humidity, condition category) collectively explains a substantial share of demand variation and reinforces segmentation strategies tailored to commuter versus leisure behavior.

## Distinctive Demand Across Time of Day

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232255.png" width="60%">
</p>

*Figure. Hourly Usage of Capital Bikeshare by Times of Day*

**Casual users exhibit a leisure-centric schedule.** Demand is **muted during early morning**, begins to build **late in the morning**, and **peaks around Midday and the Afternoon leisure window**, reflecting weather/comfort-sensitive trip purposes (often social or recreational).

**Registered users follow a structured commuter rhythm.** Demand forms a **pronounced bimodal pattern** with a **Morning Peak (commuter hours)** and an **Afternoon / Early Evening Peak**, aligning with work start and end times and indicating habitual, purpose-driven usage.

**Interpretation.** These **distinct temporal signatures** underscore the importance of **hour-of-day features** (and potential **weekday × hour interactions**) in predictive modeling:
- Casual demand volatility concentrates in the midday–afternoon band, suggesting opportunity windows for promotional upsell to membership.
- Registered demand stability at commute peaks supports operational planning for **bike availability and redistribution** during those critical windows.

Overall, the divergence between leisure-oriented and commute-oriented temporal patterns reinforces the need for **segment-specific time-based forecasting strategies**.

## Weekend and Holiday – Secondary Demand Driver

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232332.png" width="60%">
</p>

*Figure. Casual Users' Demand at Times of Day across Day Type*

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232414.png" width="60%">
</p>

*Figure. Registered Users' Demand at Times of Day across Day Type*

**Casual Users.** Demand medians on **weekends and holidays are markedly higher** than on ordinary working days, especially during the **Midday** and **Afternoon leisure window**, indicating a strong recreational and discretionary usage pattern when schedule constraints are relaxed.

**Registered Users.** In contrast, the characteristic **commuter peaks (Morning / Late Afternoon)** **depress on weekends and holidays**, while **Midday usage shows a relative lift**. This redistribution reflects a shift from routine work trips toward occasional midday errands or leisure rides. The holiday pattern mirrors the weekend structure, reinforcing the effect of non-working status on temporal demand reshaping.

**Peak Timing Shift.** Weekend and holiday status influence not only the **absolute level of demand** but also the **timing of peak hours** for each segment:
- Casual demand shifts upward into the Midday–Afternoon band.
- Registered demand flattens at traditional commute peaks and partially reallocates toward Midday.

> These dynamics highlight the importance of incorporating **weekend / holiday interaction terms with hour-of-day** (e.g., `is_weekend * hour`, `is_holiday * hour`) in predictive modeling and segmentation strategy to capture structural changes in temporal usage patterns.

## Seasonal Demand of Each User

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232845.png" width="60%">
</p>

*Figure. Proportion of Seasonal Usage*

**Casual users concentrate in warmer seasons.** Usage clusters in **Spring and Summer**, together accounting for roughly **≈ 70%** of casual rides, while **Winter drops sharply to ~20.93%**. This pattern reflects the discretionary, weather‑sensitive nature of leisure and tourism trips.

**Registered usage is more balanced across seasons.** The highest share occurs in **Summer (31.25%)**, followed by **Spring (26.76%)** and **Fall (26.64%)**, with **Winter** lowest—consistent with reduced ride comfort and shorter daylight.

> Shorter **daylight hours** and **lower temperatures** in Winter suppress cycling—most visibly for leisure behaviors—driving the lowest seasonal proportions for both segments. These findings underscore the importance of including **seasonality** in demand models and calibrating **capacity by season and segment.**

## Weather Conditions, Humidity and Temperature – Demand Booster

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232901.png" width="60%">
</p>

*Figure. Demannd of Each User and Distribution of Temperature, Humidity and Windspeed in each Weather Condition*

**While humidity co-moves with adverse weather, temperature is a weaker discriminator across most weather states.** Except on **heavy-rain days**, the **temperature median and IQR are closely similar** across other weather conditions, indicating that temperature alone is **less informative than humidity** for explaining short‑run demand variation.

> **Implications for prediction and operations.**
> - Prioritize **humidity** (and its interactions with weather condition) as a high‑signal feature in demand models.
> - For logistics, expect **demand headwinds under high humidity and adverse conditions**; bias capacity toward **clear/dry periods** and be conservative on stock/redistribution plans when **humidity is elevated**, even if temperatures are moderate.

# Customer Persona

<!-- 3-column HTML table as requested -->
<table>
  <thead>
    <tr>
      <th>Segment</th>
      <th>Primary purpose & behavior</th>
      <th>Likely destinations & trip patterns</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Casual users</strong></td>
      <td>
        Tourism and sightseeing; leisure‑oriented and schedule‑flexible.<br/>
        Usage concentrates on weekends/holidays and in the midday–afternoon window.
      </td>
      <td>
        Public parks, tourist landmarks, waterfronts, monuments, museums, and event venues.<br/>
        Short, scenic loops and point‑to‑point leisure trips.
      </td>
    </tr>
    <tr>
      <td><strong>Registered users</strong></td>
      <td>
        Structured, routine travel (work/education).<br/>
        Strong weekday commute peaks (morning and late afternoon); declines on weekends/holidays.
      </td>
      <td>
        Residential areas ↔ office districts, major transit hubs, and university zones.<br/>
        Repeated origin–destination pairs aligned to daily routines.
      </td>
    </tr>
  </tbody>
</table>

# Predictive Model

Recognizing the distinct behaviors of **Casual** and **Registered** users, we estimate separate prediction models for each segment.

## Feature Selection
To control multicollinearity, we applied **Variance Inflation Factors (VIF)** and removed collinear terms. We then used **backward elimination** (dropping features and interactions iteratively) to obtain the simplest specification that delivers the **highest accuracy** with strong statistical support.

## Model
See the Word document for complete coefficient tables and significance tests.

**Casual model**

`ln(casual + 1) = 0.672 − 0.127·EarlyMorning + 1.471·MorningPeak + 2.108·Midday + 2.056·AfternoonPeak + 1.379·Evening − 0.676·WorkingDay − 0.024·Mist_Cloudy − 0.561·LightSnow_Rain − 0.272·HeavySnow_Rain + 0.495·Spring + 0.234·Summer + 0.441·Fall + 0.457·Holiday − 0.814·Humidity + 0.053·FeltTemperature`

**Registered model**

`ln(registered + 1) = 2.079 + 1.603·EarlyMorning + 3.389·MorningPeak + 2.501·Midday + 3.441·AfternoonPeak + 2.473·Evening + 1.169·Weekend − 0.008·Mist_Cloudy − 0.432·LightSnow_Rain + 0.116·HeavySnow_Rain + 0.206·Spring + 0.152·Summer + 0.476·Fall − 0.319·Holiday − 0.615·Humidity + 0.027·FeltTemperature − 2.731·(EarlyMorning×Weekend) − 2.684·(MorningPeak×Weekend) − 0.783·(Midday×Weekend) − 1.875·(AfternoonPeak×Weekend) − 1.482·(Evening×Weekend)`

Notes
- Weather-state encodings follow the analysis (e.g., Mist_Cloudy, LightSnow_Rain).
- Log-transforming targets stabilizes variance and improves fit.

## Model Evaluation
- Adjusted R-squared: **0.769 (Casual)** and **0.799 (Registered)**, indicating **high reliability** for predicting bike usage across contexts.
- The interaction **hr_cat × weekend** increases Registered-model accuracy by **+9.2 percentage points**, versus **+1.8 pp** for the Casual model—highlighting the stronger weekend timing effect for commuters.

For detailed interpretation and diagnostic plots, refer to the accompanying Word document.

# Scenario Development

## Operational Challenges on Weekday vs. Weekend Demand

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232920.png" width="60%">
</p>

*Figure. Scenarios of Demand at Different Times of Day on Working Days*

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232933.png" width="60%">
</p>

*Figure. Scenarios of Demand at Different Times of Day on Weekends*

Assumptions: Fix season to <strong>Summer</strong>, non‑holiday; <strong>humidity</strong> and <strong>felt temperature</strong> at their Summer means.

- Weekend midday and afternoon peaks generate the highest usage. Midday is the busiest period, averaging about <strong>51 casual</strong> and <strong>237 registered</strong> trips—roughly <strong>2×</strong> weekday levels (Scenario 5).  
  Although routine commuting declines for registered users on weekends, they still ride for non‑work purposes (shopping, leisure), shifting activity toward midday.

## Operational Challenges Across Seasons

<p align="center">
  <img src="https://github.com/Truong2003-tqd/Demand-Prediction-for-Capital-Bikeshare-Company/blob/101b58ce1dcd1560ec00906517b593bd63ffdbc5/image/Screenshot%202025-11-12%20232944.png" width="60%">
</p>

*Figure. Scenarios of Demand in Differnt Seasons*

Assumptions: Fix <strong>Afternoon Peak</strong>, non‑weekend, non‑holiday, clear weather; vary <strong>humidity</strong> and <strong>felt temperature</strong> by seasonal means.

- Seasonal climate creates distinct high/low traffic periods.  
  <strong>Summer</strong> brings excess demand risks (bike shortages, station congestion, accelerated wear).  
  <strong>Winter</strong> introduces under‑utilization risks and resource inefficiency.

# Recommendations

## Time-Based Bike Rebalancing & Station Placement Optimization

Assumptions: Normal (non-holiday) day unless noted; humidity/temperature at seasonal means. Aim to keep 20–30% free dock capacity at high-demand stations and >90% bike availability at AM commuter origins.

Weekday operations
**1) Morning Peak (6:00–9:00)**
- Pre‑load bikes to residential catchments and near transit feeders to support outbound commuter flows from registered users.
- Maintain conservative stock in office districts to avoid early depletion.

**2) Midday Reinforcement (10:00–16:00)**
- Relocate ~70% of surplus from underutilized “Type A” stations (residential, far from tourism/leisure) to “Type B” high‑demand stations (office districts, leisure areas), retaining a minimal operating buffer at Type A.
- Rationale: casual demand is significantly higher mid‑day and near leisure destinations; this also stages inventory for the afternoon commuter peak.

**3) Afternoon Return Allocation from Closing Tourist Spots (16:00–17:00)**
- Reclaim bikes from early‑closing attractions and cultural venues and reposition to office districts ahead of the PM commute surge.

**4) Evening Rebalancing (20:00–23:00)**
- Shift inventory from peripheral, low‑activity zones to central business and entertainment districts using a ~70:30 redistribution ratio to support nightlife/leisure demand.

**5) Overnight Positioning (post 23:00)**
- Stage unused bikes back to residential areas for early‑morning commuter readiness (registered user peaks).

**Weekend operations**

**6) Leisure‑Oriented Allocation (All Day)**
- Concentrate allocation within ~3–5 km of the CBD and along tourism/leisure corridors (parks, waterfronts, landmarks, event venues). Expect sustained midday–afternoon activity and lighter commute peaks.

## Optimize the Rotation Maintenance Cycle

Concentrate preventive maintenance in **Winter**, when total demand is <50% of peak, to minimize user impact while preparing for the **Spring–Summer** surge.

**1) Phase 1 — Leisure/Tourist Stations (withdraw, service, buffer)**
- Evidence: Casual usage drops by **>90%** in Winter (vs. Spring), while Registered declines by **~57%**.
- Action: Withdraw the majority of bikes from tourist‑attractive stations for **preventive check‑ups** (safety, drivetrain, brakes, lighting) and deep cleaning. Maintain a **~20% buffer** to preserve basic availability for residual trips and local needs.

**2) Phase 2 — Redistribute Maintained Bikes to Office and Residential Stations**
- Goal: Ensure availability for Registered users’ commuter traffic during off‑peak season.
- Action: Re‑deploy serviced bikes to **AM‑origin stations** (residential/transit feeders) and balance office‑district docks for PM returns. Prioritize stations by utilization KPIs (e.g., morning stock‑out risk, afternoon dock‑full risk).

**3) Phase 3 — Service Remaining Office/Residential Bikes (rolling window)**
- Action: Pull an equal number of unmaintained units from office/residential locations—especially those nearing mileage/usage thresholds—into the **next rotation**. This rolling cycle sustains service continuity while steadily raising the fleet’s quality baseline.

**4) Safeguards and KPIs**
- Preserve minimum service levels: do not reduce tourist attraction inventory below **~20%** during holidays/events.  
- Monitor station‑level KPIs: stock‑out rate (AM peaks), dock‑full rate (PM peaks), mean time since last service.  


**Outcome**
This rotation compresses downtime into low‑demand months, maintains commuter reliability, and readies the system for Spring/Summer demand, improving both availability and safety.


