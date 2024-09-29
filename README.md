# SQL for Sakila

This is a collaborative personal portfolio project between [Amanda Huang](https://www.linkedin.com/in/amanda-huang9/) and [Ayush Shrestha](https://www.linkedin.com/in/ayush-yoshi-shrestha/). The data analyzed is the Sakila dataset, originally developed by Mike Hillyer of the MySQL AB documentation team and accessible for PostgreSQL [here](https://github.com/jOOQ/sakila).

## Introduction

The dataset is a comprehensive multi-table relational database consisting of 15 tables, designed to capture the global operations of a movie rental store. It includes detailed information on customer demographics and rental activity, as well as payment records and the store's movie inventory across locations.

Although video rental stores are rare in today's market, the principles underlying this analysis remain relevant for many businesses, such as e-commerce platforms and streaming services.

Our goal is to provide Sakila with actionable insights into key revenue drivers, rental patterns, and customer behavior. This includes factors like movie popularity, late returns, and geographic location to help optimize business decisions and strategies. The findings will enable Sakila to make informed decisions on budget allocation for new film acquisitions, maintain optimal inventory levels by predicting late returns, and enhance supply chain efficiency across different regions.

## Methodology

We utilize PostgreSQL to host the database and perform our analysis, employing techniques such as:

- Joins for combining data across multiple tables
- Common Table Expressions (CTEs) for simplifying complex queries
- OLAP (Online Analytical Processing) functions, including Cube, Rank, and Partitioning, for advanced data analysis
- CASE statements for conditional logic within queries

We further leverage Power BI and Tableau to develop dynamic dashboards and visualizations that effectively communicate our key findings. These include:

- Bar charts
- Scatter plots
- Treemaps
- Combo charts

These visualizations enable stakeholders to interact with the data, facilitating deeper understanding and empowering them to refine strategies based on evolving business needs.

## Data Processing & Exploratory Data Analysis (EDA)

Data processing and EDA were conducted using PostgreSQL to prepare the data for more advanced analysis and to gain a comprehensive understanding of the relationships between the tables. The complete Entity Relationship Diagram (ERD) is presented below, serving as a crucial reference that guided our analysis.

![sakila-ERD](sakila-erd.png)

Building on the business objectives outlined in the Introduction, the EDA focused primarily on the following tables:

- Film
- Customer
- Country
- Rental
- Payment

These tables provided the foundation for exploring relationships, identifying trends, and uncovering patterns within the dataset. Key observations from the EDA include:

- All films are in the same primary language: English.
- There are two main stores from which customers place rental orders.
- A subset of films has not been returned.
- Late payments are generally higher than the initial rental rate of the movies.

The EDA also highlighted important aspects regarding data quality and usability. While the critical tables for our analysis contained sufficient data, some supplementary tables were relatively sparse and less informative. This can be attributed to the synthetic nature of the dataset but was nonetheless an important insight. For example, there is typically only one customer per city, meaning that aggregating data at the country level is necessary to detect patterns in customer behavior.

With this foundation established, we proceeded to the first phase of our analysis.

## Analysis

To keep our objectives clear, we defined 3 categories within which to analyze:

1. _Revenue & Popularity_: Looking at the relationship between total revenue and rental volume, as well as the breakdown of regular revenue vs late fee revenue
2. _Lateness_: Investigating what kinds of movies are more or less likely to be returned late, and by what magnitude of lateness
3. _Customers_: Understanding the distribution of customers by country of residence, as well as which store they most frequently interact with

## Findings and Recommendations
