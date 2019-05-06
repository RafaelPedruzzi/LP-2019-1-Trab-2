--[[
Linguagens de Programação - Prof. Flavio Varejão - 2019-1
Segundo trabalho de implementação

Aluno: Rafael Belmock Pedruzzi

point.lua:	módulo responsável pela implementação dos calculos e
			estruturas feitos com pontos muldidimensionais
--]]

point = {}

-- Função que calcula a distância euclidiana entre dois pontos
-- parâmetros: dois vetores, p1 e p2, representando os pontos.
-- retorno: a distância euclidiana entre p1 e p2.
-- pré-condição: p1 e p2 devem ter o mesmo número de dimensões.
function point.dist(p1,p2)
	sum, sub = 0, 0
	for i = 1, #p1 do
		sub = (p1[i] - p2[i])
		sum = sum + sub * sub
    end
	return math.sqrt(sum)
end

-- Função que monta os grupos segundo o algoritimo de agrupamento por líder
-- parâmetros: a distância maxima entre um ponto e seu líder e o vetor de pontos.
-- retorno: uma tabela g contendo um vetor com os grupos formados (líder é o ponto na primeira posição do vetor do grupo) e uma referência para o vetor de pontos.
-- condição: todos os pontos devem ter o mesmo número de dimensões.
-- pós-condição: estruturas inalteradas.
function point.makeGroups(dist, p)
    local g = {points = p} -- inicializando g com uma referência para o vetor de pontos.
	local lider            -- variável auxiliar usada para reconhecer novos líderes.

	-- Montando os grupos.
    g.groups = {}	   -- criando o vetor de grupos
    g.groups[1] = {}   -- criando o primeiro grupo.
	g.groups[1][1] = 1 -- adicionando o primeiro ponto como líder do primeiro grupo.

	-- Adicionando/criando os demais pontos/grupos.
	for i = 2, #(g.points) do -- para cada ponto i no vetor de pontos.
		for j = 1, #(g.groups) do -- para cada grupo j em g.

			local p = g.groups[j][1] -- posição do líder do grupo j no mapa.
			lider = true

			-- Verificando se a distância do ponto i ao lider do grupo j é menor ou igual a dist. Caso verdadeiro, i é adicionado a j.
			if point.dist(g.points[i], g.points[p]) <= dist then
				table.insert(g.groups[j], i)
				lider = false
				break
            end
		end
		-- Caso i seja líder, um novo grupo será criado com i como líder.
        if lider then
            g.groups[#(g.groups)+1] = {}
			g.groups[#(g.groups)][1] = i
        end
	end

	return g
end

-- Função que calcula o centro de massa de um grupo
-- parâmetros: o vetor de grupos e a posição do grupo nesse vetor.
-- retorno: vetor representando o ponto do centro de massa do grupo.
-- pós-condição: estruturas inalteradas.
function point.centroMassa(g, pos)
	local c = {} -- centro de massa

	-- Inicializando c
	for i = 1, #(g.points[1]) do
		c[i] = 0
    end

	-- Realizando o somatório de todos os pontos do grupo em c
	for i = 1, #(g.groups[pos]) do
		local p = g.groups[pos][i]

		for j = 1, #c do
			c[j] = c[j] + g.points[p][j]
        end
	end

	-- Dividindo cada coordenada de c pelo número de elementos no grupo
	for i = 1, #c do
		c[i] = c[i] / #(g.groups[pos])
    end

	return c
end

-- Função que calcula a SSE de um agrupamento
-- parâmetros: o vetor de grupos.
-- retorno: valor da SSE do agrupamento.
-- pós-condição: estruturas inalteradas.
function point.sse(g)
	local sse, groupSum -- sse: resultado da sse; groupSum: auxiliar para o somatório de cada grupo.
	sse = 0

	for i = 1, #(g.groups) do -- para cada grupo i na lista de grupos.
		local cMassa = point.centroMassa(g,i)
		groupSum = 0

		for j = 1, #(g.groups[i]) do -- para cada elemento j do grupo i.
			local d = point.dist(g.points[g.groups[i][j]], cMassa) -- d = distância entre o ponto j e o centro de massa do grupo.
			groupSum = groupSum + d * d -- atualizando somatório do grupo atual.
        end

		sse = sse + groupSum -- SSE será a soma de todos os somatórios parciais.
	end

	return sse
end

return point
