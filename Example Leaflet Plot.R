# -- Setup -------

# Libraries
library(htmlwidgets)

# Auxiliary Scripts
##Read in "Leaflet_Residuals_Plot.R"

# -- Data Prep -------

# Create a dataset with one row per sector and some extra features (for plot labels)
SECTOR_Prediction = Model_For_Plot$POSTCODE_Prediction %>%
  mutate(
    PCODE_SECT = substring(POSTCODE,1,nchar(POSTCODE)-2)
  )%>%
  group_by(
    PCODE_SECT
  )%>%
  summarise(
    Prediction = mean(Prediction,na.rm=TRUE) ## This is the label I want for each sector!
  )

# -- Create a leaflet plot object -------

Plot <- Leaflet_Residuals_Plot(
  Sector_Residuals_Data = SECTOR_Prediction
  ,Sector_Residuals_Field = "Prediction"
  ,PCode_Sector_Field = "PCODE_SECT" #Name of the field containing the postcode sector
  ,MinValue_For_Palette = NULL #If NULL, will derive from the data
  ,MaxValue_For_Palette = NULL #If NULL, will derive from the data
  ,smoothFactor = 1
) 

# -- Save Plot -------

# As html object ... Takes about 30 seconds
saveWidget(
  Plot
  ,file = paste0(
    ProjectWD,"Outputs\\",Analysis_Scenario,"\\Heatmap Plots\\LeafletPlot_",MODEL,".html"
  )
  ,selfcontained = FALSE
)        

#AND as an RDS object [Probably not necessary for Sindy unless needing it to pass into Markdown]
saveRDS(
  Plot
  ,paste0(ProjectWD,"Outputs\\",Analysis_Scenario,"\\Heatmap Plots\\LeafletPlot_",MODEL,".rds")
)     

