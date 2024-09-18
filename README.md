# SQL for Sakila

This is an **in-progress** collaborative personal portfolio project between [Amanda Huang](https://www.linkedin.com/in/amanda-huang9/) and [Ayush Shrestha](https://www.linkedin.com/in/ayush-yoshi-shrestha/). The dataset used is the Sakila dataset, originally developed by Mike Hillyer of the MySQL AB documentation team and accessible for PostgreSQL [here](https://github.com/jOOQ/sakila)

## Instructions

The Sakila dataset was chosen for its comprehensive relational data model, offering opportunities for complex joins, CTEs, and OLAP (Online Analytical Processing) functions, including Cube, Rank, and Partition. CASE statement were also utilized to aid in effective data querying and analysis.
The Exploratory Data Analysis (EDA) files can be accessed [here](eda), and the analysis files are available [here](analysis).

## Overview

Although video rental stores are rare in today's market, the principles underlying this analysis remain relevant for many businesses. This project aims to provide the Sakila DVD rental store with insights into how revenue is influenced by factors such as movie popularity and late fees. Additionally, it seeks to identify patterns in late returns and understand the geographic distribution of rentals and revenue, based on customer locations and store interactions.

To achieve these objectives, we conduct a series of analyses using PostgreSQL and Power BI. The findings will enable Sakila to make informed decisions on budget allocation for new film acquisitions, maintain optimal inventory levels by predicting late returns, and enhance supply chain efficiency across different regions.

## Exploratory Data Analysis (EDA)

EDA was conducted using PostgreSQL to gain an overall understanding of the dataset and the relationships between the tables. The complete Entity Relationship Diagram (ERD) is presented below:

![sakila-ERD](sakila-erd.png)

The emphasis of the analysis, and consequently the EDA, primarily focused on the following tables:

- Film
- Customer
- Country
- Rental
- Payment

By joining key tables and calculating relevant metrics, we obtained a clear understanding of the dataset's relationships. With this foundation, we proceeded to the first phase of the analysis.

## Analysis

To keep our objectives clear, we defined 3 categories within which to analyze:

1. _Revenue & Popularity_: Looking at the relationship between total revenue and rental volume, as well as the breakdown of regular revenue vs late fee revenue
2. _Lateness_: Investigating what kinds of movies are more or less likely to be returned late, and by what magnitude of lateness
3. _Customers_: Understanding the distribution of customers by country of residence, as well as which store they most frequently interact with

## Findings and Recommendations
