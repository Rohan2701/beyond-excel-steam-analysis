# beyond-excel-steam-analysis
An end-to-end data analytics pipeline analyzing 122,000+ Steam games. Bypassed Excel limitations using WSL &amp; MySQL, culminating in a dynamic Power BI dashboard.

# 🎮 Steam Market Analysis: An End-to-End Data Pipeline

## 📖 Overview
This project is a comprehensive analysis of over 122,000 games on the Steam platform. The goal was to uncover actionable business insights regarding pricing strategies, market saturation, and player engagement across different genres. 

What started as a standard data project quickly evolved into a lesson in technical problem-solving when the sheer volume of data broke standard spreadsheet tools, requiring a pivot to a more robust, programmatic pipeline.

---

## 🔍 1. Why the Steam Games Dataset?
I chose this dataset for two reasons:
1. **Scale:** The gaming industry is massive, and Steam is its biggest PC storefront. Analyzing this data provides genuine, real-world market insights.
2. **Complexity:** Real-world data is messy. This dataset contained nested comma-separated genres, wildly varying price tiers, and anomalies (like paid games tagged as "Free to Play") that required rigorous cleaning and relational modeling.

---

## 💥 2. The Bottleneck: When Excel Broke
**The Problem:**
My initial plan was to perform preliminary data cleaning in MS Excel. However, attempting to load and process over 122,000 rows with complex text strings completely froze the application. 

**The Workaround (WSL & Linux):**
Instead of downsizing the data, I upgraded my environment. I utilized Windows Subsystem for Linux (WSL) to handle the file operations. 
* *Personal Milestone:* Rather than just copy-pasting commands from Stack Overflow, I took the time to genuinely understand the Linux command-line architecture, using terminal commands to navigate, inspect, and prepare the massive CSV file for database ingestion.

---

## ⚙️ 3. The Engine: MySQL & Data Cleansing
With the data prepped, I built a local MySQL database to act as the analytical engine.

**The `@dummy` Variable Trick:**
During the `LOAD DATA INFILE` process, certain columns in the raw CSV were unnecessary or improperly formatted. I utilized `@dummy` variables in my SQL import script to selectively bypass useless columns and keep the database lightweight and optimized.

**Analytical Queries:**
I wrote and executed 10 complex SQL queries to establish the foundational metrics, including:
* Identifying peak concurrent user (CCU) outliers.
* Grouping developers by release volume.
* Filtering out false "Free to Play" anomalies.

*(Note: The full `.sql` script containing the table schema and the 10 queries is included in this repository).*

---

## 📊 4. The Visuals: Power BI & Data Modeling
The final stage was translating the raw SQL findings into an interactive, stakeholder-ready dashboard.

**Key Technical Achievements in Power BI:**
* **Relational Data Modeling (Star Schema):** The raw data contained multiple genres crammed into a single text string (e.g., "Action, RPG, Adventure"). I used Power Query to split these by delimiter into rows, creating a dedicated **Genre Bridge Table**. This allowed accurate, independent genre tracking without duplicating the master game count.
* **Advanced DAX (`SWITCH`):** Instead of messy nested `IF` statements, I wrote custom DAX `SWITCH` functions to bucket thousands of individual game prices into clean, logical pricing tiers (Free, Budget, Mid-level, AAA, Premium).
* **Time Intelligence:** Extracted release years from raw datetime data to build a trend line showing the explosive market saturation of Steam over the last decade.

---

## 🚀 5. The Final Output
The culmination of this pipeline is a fully interactive Power BI dashboard designed to answer business questions instantly.

▶️ **[Watch the 30-Second Dashboard Demo Here]** https://github.com/Rohan2701/beyond-excel-steam-analysis/blob/main/Recording%202026-04-14%20022752.mp4

![Dashboard Screenshot]((https://github.com/Rohan2701/beyond-excel-steam-analysis/blob/main/Screenshot%202026-04-14%20024227.png))
