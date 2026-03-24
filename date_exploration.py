# import libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px

# Improve visualization style
sns.set(style="whitegrid")

# Path
trades = pd.read_csv("trading_transactions.csv")
clients = pd.read_csv("clients.csv")
stocks = pd.read_csv("stock_master.csv")
market_data = pd.read_csv("daily_market_data.csv")
commissions = pd.read_csv("commission_rates.csv")

# Quick look at the data
print(trades.head())
print(clients.head())
print(stocks.head())

# Merge trades with clients and stock info
trades_clients = trades.merge(clients, on="client_id", how="left")
trades_clients_stocks = trades_clients.merge(stocks, on="stock_id", how="left")

# Check merged data
print(trades_clients_stocks.head())

# top traded stocks by gross value
top_stocks = trades_clients_stocks.groupby('symbol_x')['gross_value_thb'].sum().sort_values(ascending=False).head(10).reset_index()

plt.figure(figsize=(10,6))
sns.barplot(data=top_stocks, x='gross_value_thb', y='symbol_x', palette="viridis")
plt.title("Top 10 Traded Stocks by Gross Value")
plt.xlabel("Gross Value (THB)")
plt.ylabel("Stock Symbol")
plt.show()

# pie chart stock segment proportion
sector_trade = trades_clients_stocks.groupby('sector')['gross_value_thb'] \
    .sum() \
    .reset_index()

total_value = sector_trade['gross_value_thb'].sum()

sector_trade['percentage'] = (sector_trade['gross_value_thb'] / total_value) * 100

sector_trade = sector_trade.sort_values(by='percentage', ascending=False)

print(sector_trade)

plt.figure(figsize=(7,7))
plt.pie(
    sector_trade['gross_value_thb'],
    labels=sector_trade['sector'],
    autopct='%1.1f%%',
    startangle=140
)

plt.title("Proportion of Trading Value by Sector")
plt.show()

# Count clients by segment and region
client_distribution = clients.groupby(['segment','region']).size().reset_index(name='count')

plt.figure(figsize=(12,6))
sns.barplot(data=client_distribution, x='region', y='count', hue='segment')
plt.title("Client Distribution by Segment and Region")
plt.ylabel("Number of Clients")
plt.show()

# dive down into the south
south_retail = clients[
    (clients['region'] == 'South') &
    (clients['segment'] == 'Retail')
]

south_province_dist = south_retail.groupby('province') \
    .size() \
    .reset_index(name='count') \
    .sort_values(by='count', ascending=False)

top5 = south_province_dist.head(5)

plt.figure(figsize=(8,5))
sns.barplot(data=top5, x='count', y='province', palette="viridis")

plt.title("Top 5 Provinces (South - Retail Clients)")
plt.xticks(range(0, south_province_dist['count'].max()+1))
plt.show()

# trade value outlier using boxplot
client_total = trades_clients_stocks.groupby(['client_id', 'segment'])['gross_value_thb'] \
    .sum() \
    .reset_index()

# Function to detect outliers per segment
def detect_outliers(group):
    Q1 = group['gross_value_thb'].quantile(0.25)
    Q3 = group['gross_value_thb'].quantile(0.75)
    IQR = Q3 - Q1
    upper_bound = Q3 + 1.5 * IQR

    group['is_outlier'] = group['gross_value_thb'] > upper_bound
    return group

client_outliers_segment = client_total.groupby('segment', group_keys=False).apply(detect_outliers)
outlier_counts = client_outliers_segment.groupby('segment')['is_outlier'] \
    .sum() \
    .reset_index()

outlier_counts.columns = ['segment', 'outlier_count']

print(outlier_counts)
total_counts = client_outliers_segment['segment'].value_counts().reset_index()
total_counts.columns = ['segment', 'total_clients']

comparison = outlier_counts.merge(total_counts, on='segment')
comparison['outlier_pct'] = (comparison['outlier_count'] / comparison['total_clients']) * 100

print(comparison)
plt.figure(figsize=(10,6))
sns.boxplot(data=client_total, x='segment', y='gross_value_thb')

plt.yscale('log')
plt.title("Client Trading Value by Segment (Outlier Detection)")
plt.xlabel("Segment")
plt.ylabel("Total Trading Value (log scale)")

plt.show()

# commission trend
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

transactions = pd.read_csv("trading_transactions.csv")
clients = pd.read_csv("clients.csv")
df = transactions.merge(clients[['client_id', 'segment', 'region']], on='client_id', how='left')

# Convert trade_date to datetime & extract month
df['trade_date'] = pd.to_datetime(df['trade_date'])
df['trade_month'] = df['trade_date'].dt.to_period('M').astype(str)  # Convert Period to string for plotting

# Aggregate commissions by month
pivot_segment = pd.pivot_table(
    df,
    index='trade_month',
    columns='segment',
    values='commission_thb',
    aggfunc='sum'
)

pivot_region = pd.pivot_table(
    df,
    index='trade_month',
    columns='region',
    values='commission_thb',
    aggfunc='sum'
)

# plot by segment
plt.figure(figsize=(12,6))
sns.lineplot(data=pivot_segment, marker='o')
plt.title('Monthly Commission Trend by Customer Segment')
plt.xlabel('Month')
plt.ylabel('Total Commission (THB)')
plt.xticks(rotation=45)
plt.legend(title='Segment')
plt.tight_layout()
plt.show()

# plot by region
plt.figure(figsize=(12,6))
sns.lineplot(data=pivot_region, marker='o')
plt.title('Monthly Commission Trend by Region')
plt.xlabel('Month')
plt.ylabel('Total Commission (THB)')
plt.xticks(rotation=45)
plt.legend(title='Region')
plt.tight_layout()
plt.show()