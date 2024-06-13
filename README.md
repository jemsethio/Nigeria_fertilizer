
# Maize Fertilizer Optimization for Nigeria

This repository contains the code and documentation for developing tailored fertilizer advice for maize growers in Nigeria using field trials data. The project involves executing an analytical workflow, performing exploratory data analysis (EDA), and documenting the process in R Markdown. 

## Project Overview

### Objectives
- Develop tailored fertilizer recommendations for maize growers in Nigeria.
- Perform exploratory data analysis (EDA) on field trials data.
- - Document the analytical workflow
- Share reusable scripts 

### Files in this Repository
- `Maize_Nigeria_Fertilizer_ML.ipynb`: Jupyter notebook containing the main analytical workflow and model development.
- `Nigeria_CS_fertilizer.Rmd`: R Markdown document detailing the EDA and the steps taken to develop the fertilizer recommendations.

### Getting Started

#### Prerequisites
- Python (version 3.7+)
- R (version 4.0+)
- Jupyter Notebook
- RStudio (optional, for R Markdown)

#### Installation

1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/Nigeria_fertilizer.git
   cd Nigeria_fertilizer
   ```

2. **Install required Python packages:**
   ```sh
   pip install -r requirements.txt
   ```

3. **Install required R packages:**
   ```R
   install.packages(c("tidyverse", "caret", "randomForest","rmarkdown"))
   ```

### Usage

#### Running the Jupyter Notebook
To execute the analytical workflow, open the `Maize_Nigeria_Fertilizer_ML.ipynb` file in Jupyter Notebook and run the cells sequentially.

#### Rendering the R Markdown Document
To generate the report from the R Markdown document, open `Nigeria_CS_fertilizer.Rmd` in RStudio and click the "Knit" button to render the document into HTML or PDF format.

### Project Structure
- `data/`: Directory containing the field trials data.
- `scripts/`: Directory containing reusable scripts for data downloading, preprocessing, modeling, and analysis.
- `output/`: Directory for storing model outputs and reports.
- `notebooks/`: Directory for Jupyter notebooks.
- `README.md`: Project overview and setup instructions.

### Contributing
Contributions are welcome! Please fork the repository and submit pull requests with detailed descriptions of your changes.

### License
This project is licensed under the MIT License. See the `LICENSE` file for more details.

### Contact
For any questions or inquiries, please contact jemalseid.ahmed@santannapisa.it.
