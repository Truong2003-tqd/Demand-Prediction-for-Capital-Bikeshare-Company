# Declaration of Authorship
The report is an assignment of my course in RMIT, articulated by 3 collaborators.
_**Xuan Truong:** 

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


