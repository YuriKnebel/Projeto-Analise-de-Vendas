--Sele��o dos dados da tabela DimDate

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
	CalendarYear >= 2019 -- Filtragem para que s� apare�am datas a partir de 2019
ORDER BY 
	FullDateAlternateKey;


-- Sele��o dos dados da tabela DimCustomer


SELECT 
	c.customerkey, 
	c.firstname AS nome, 
	c.lastname AS sobrenome, 
	c.firstname + ' ' + lastname AS nome_completo,
	CASE c.gender WHEN 'M' THEN 'Masculino' WHEN 'F' THEN 'Feminino' END AS genero, -- Altera��o do conte�do da coluna para melhor a leitura dos dados
	c.datefirstpurchase AS primeira_compra,
	g.city AS cidade
FROM 
	AdventureWorksDW2019.dbo.DimCustomer as c
	LEFT JOIN dbo.dimgeography AS g ON g.geographykey = c.geographykey -- utiliza��o do LEFT JOIN para que a coluna cidade pudesse ser utilizada nesta tabela
ORDER BY 
	CustomerKey ASC


-- Sele��o dos dados da tabela DimProduct


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
	ISNULL (p.Status, 'Outdated') AS status_produto -- Substitui��o dos dados nulos
FROM 
	AdventureWorksDW2019.dbo.DimProduct as p
	LEFT JOIN dbo.DimProductSubcategory AS ps ON ps.ProductSubcategoryKey = p.ProductSubcategoryKey 
	LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
	-- Utiliza��o de LEFT JOIN para jun��o de diversas tabelas
ORDER BY
	p.ProductKey asc


-- Sele��o dos dados da tabela FactInternetSales --


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

