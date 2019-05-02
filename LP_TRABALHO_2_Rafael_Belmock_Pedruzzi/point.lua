--[[
Linguagens de Programação - Prof. Flavio Varejão - 2019-1
Segundo trabalho de implementação

Aluno: Rafael Belmock Pedruzzi

point.lua:	módulo responsável pela implementação dos calculos e
			estruturas feitos com pontos muldidimensionais
--]]

point = {}

-- Struct que define um grupo de pontos
-- groups: slice representando o conjunto de grupos. Cada grupo é representado por uma slice de inteiros positivos que são os ids dos pontos mapesdos em points. O primeiro ponto de cada grupo é o lider do grupo.
-- points: mapa de pontos.
-- point.G = {
-- 	groups,
-- 	points
-- }

-- Método de Point que calcula a distância euclidiana entre dois pontos
-- parâmetros: um ponto p2.
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
-- parâmetros: a distância maxima entre um ponto e seu líder e u ponteiro para o mapa de pontos.
-- retorno: um struct Groups contendo os grupos formados.
-- condição: todos os pontos devem ter o mesmo número de dimensões.
-- pós-condição: estruturas inalteradas.
function point.makeGroups(dist, p)
    local g = {points = p} -- inicializando g com o ponteiro para o mapa de pontos.
	local lider            -- variável auxiliar usada para reconhecer novos líderes.

	-- Montando os grupos.
    -- Criando o primeiro grupo e adicionando o primeiro ponto como seu líder.
    g.groups = {}
    g.groups[1] = {}
	g.groups[1][1] = 1

	-- Adicionando/criando os demais pontos/grupos.
	for i = 2, #(g.points) do -- para cada ponto i no mapa de pontos.
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
		-- Caso i seja líder, um novo grupo será criado para i.
        if lider then
            g.groups[#(g.groups)+1] = {}
			g.groups[#(g.groups)][1] = i
        end
	end

	return g
end

-- Método para calculo do centro de massa de um grupo
-- parâmetros: a posição do grupo na lista de grupos.
-- retorno: ponto do centro de massa do grupo.
-- pós-condição: estruturas inalteradas.
function point.centroMassa(g, pos)
	local c = {}

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

-- Método para calculo da SSE de um agrupamento
-- retorno: SSE do agrupamento (float64).
-- pós-condição: estruturas inalteradas.
function point.sse(g)
	local sse, groupSum -- resultado da sse e auxiliar para o somatório de cada grupo.
	sse = 0

	for i = 1, #(g.groups) do -- para cada grupo i na lista de grupos.
		local cMassa = point.centroMassa(g,i)
		groupSum = 0

		for j = 1, #(g.groups[i]) do -- para cada elemento j do grupo i.
			local d = point.dist(g.points[g.groups[i][j]], cMassa) -- d = distância entre o ponto j e o centro de massa do grupo.
			groupSum = groupSum + d * d
        end

		sse = sse + groupSum -- SSE será a soma de todos os somatórios parciais.
	end

	return sse
end

return point
