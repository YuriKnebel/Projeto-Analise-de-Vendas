# Projeto de Análise de Vendas

Nesse estudo foi utilizado o banco de dados AdventureWorks, fornecido pela Microsoft através do link: https://docs.microsoft.com/pt-br/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms.  O banco de dados AdventureWorks é um exemplo de funcionamento de empresa e possui diversas tabelas de onde é possível extrair muita informação, com dados que vão desde a definição dos produtos até o cliente final. A versão utilizada foi AdventureWorksDW2019, que possui dados de Data Warehouse.

O objetivo deste projeto é simular uma situação de negócio, onde a gerência solicita um gráfico interativo para que sejam respondidas as seguintes questões:

1) Quais são os clientes com mais compras?
2) Quais produtos estão com melhor desempenho?
3) Nos Estados Unidos, onde estão concentradas as vendas?
4) Montar um KPI comparativo entre as vendas os gastos da empresa.
5) Quais são as categorias de produtos com maior expressão para o negócio?

O período de tempo a ser analisado deverá ter início em 2019.
Para comparação entre vendas e gastos foi fornecida uma tabela de gastos totais da empresa.

## Seleção e filtragem de dados com SQL Server

Foram selecionadas as tabelas DimDate, DimCustomer, DimProduct, FactInternetSales.

Seleção dos dados da tabela DimCustomer:
````
SELECT 
	DateKey, 
	FullDateAlternateKey AS data, 
	EnglishDayNameOfWeek AS dia, 
	EnglishMonthName AS mes, 
	LEFT(EnglishMonthName, 3) AS abrev_Mes,
	MonthNumberOfYear AS num_Mes, 
	CalendarQuarter AS quadrimestre, 
	CalendarYear AS ano
FROM 
	AdventureWorksDW2019.dbo.DimDate
WHERE 
	CalendarYear >= 2019 -- Filtragem para que só apareçam datas a partir de 2019
ORDER BY 
	FullDateAlternateKey;
````
Seleção dos dados da tabela DimProduct:

````
SELECT 
	c.customerkey, 
	c.firstname AS nome, 
	c.lastname AS sobrenome, 
	c.firstname + ' ' + lastname AS nome_completo,
	CASE c.gender WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Feminino' END AS genero, 
        -- Alteração do conteúdo da coluna para melhor a leitura dos dados
	c.datefirstpurchase AS primeira_compra,
	g.city AS cidade
FROM 
	AdventureWorksDW2019.dbo.DimCustomer as c
	LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey 
        -- utilização do LEFT JOIN para que a coluna cidade pudesse ser utilizada nesta tabela
ORDER BY 
	CustomerKey ASC
````
Seleção dos dados da tabela DimProduct:
````
SELECT 
	p.ProductKey, 
	p.ProductAlternateKey AS codigo_produto, 
	p.EnglishProductName AS nome_produto, 
	ps.EnglishProductSubcategoryName AS subcategoria,
	pc.EnglishProductCategoryName AS categoria_produto,
	p.Color AS cor_produto, 
	p.Size AS tamanho_produto, 
	p.ProductLine AS linha_produto, 
	p.ModelName AS nome_modelo, 
	p.EnglishDescription AS descricao_produto, 
	ISNULL (p.Status, 'Outdated') AS status_produto -- Substituição dos dados nulos
FROM 
	AdventureWorksDW2019.dbo.DimProduct as p
	LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
	LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
        -- Utilização de LEFT JOIN para junção de diversas tabelas
ORDER BY
	p.ProductKey asc
````
Seleção dos dados da tabela FactInternetSales:
````
SELECT 
	ProductKey, 
	OrderDateKey, 
	DueDateKey, 
	ShipDateKey, 
	CustomerKey, 
	SalesOrderNumber, 
	SalesAmount AS valor_vendas
FROM 
	AdventureWorksDW2019.dbo.FactInternetSales
WHERE 
	LEFT (OrderDateKey, 4) >= YEAR(GETDATE()) -3 -- procura apenas as ordens de 2019 para cima
ORDER BY
  	OrderDateKey ASC
  ````
## Dashboard Power BI:

Para acessar o dashboard interativo no Power BI é preciso abrir o seguinte arquivo: [analise_vendas.pbix](https://github.com/YuriKnebel/Projeto-Analise-de-Vendas/blob/main/Dashboard-Power-BI/analise_vendas.pbix)

Abaixo está a imagem do dashboard final:

![alt text](https://github.com/YuriKnebel/Projeto-Analise-de-Vendas/blob/main/Dashboard-Power-BI/screenshot_dashboard.png)


