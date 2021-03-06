--[[
Linguagens de Programação - Prof. Flavio Varejão - 2019-1
Segundo trabalho de implementação

Aluno: Rafael Belmock Pedruzzi

trabIO.lua:	módulo responsável pelo tratamento de I/O dos arquivos:
			entrada.txt, distancia.txt, result.txt e saida.txt
--]]

trabIO = {}

-- Função para leitura dos arquivos entrada.txt e distancia.txt
-- parâmetros: nenhum.
-- retorno: a distância limite e um ponteiro para um vetor contendo vetores que representam cada ponto lido (a posição no vetor indica a linha que foi lido).
function trabIO.readEntry()
	local dist = 0    -- dist: distância limite.
	local points = {} -- points: vetor de pontos.

	-- Abrindo arquivo distancia.txt para obter a distância limite.
	local distFile = io.open("./distancia.txt", "r")
	if distFile == nil then
        print("Erro ao abrir distancia.txt")
		return nil
    end

    dist = distFile:read("*n") -- lendo distância limite.
    distFile:close()

	-- Função auxiliar para converter o formato string da leitura emum vetor de números.
    local function toVector(s)
        local t = {}
        s:gsub('%-?%S+', function(n) t[#t+1] = tonumber(n) end) -- selecionando cada valor separado por espaços, convertendo-os para numero e armazenando em t.
        return t
    end

    -- Abrindo arquivo entrada.txt para obter os pontos.
	local entrFile = io.open("./entrada.txt", "r")
	if entrFile == nil then
        print("Erro ao abrir entrada.txt")
		return nil
    end

	-- Escaneando cada linha de entrada.txt e armazenando os pontos em points.
	for line in entrFile:lines() do
        local p = toVector(line)

		points[#points+1] = p -- (número da linha é a posição do ponto no vetor)
    end

	return dist, points
end

-- Funcão para impressão do arquivo saida.txt
-- parâmetros: o vetor de grupos.
-- pós-condição: estruturas inalteradas.
function trabIO.writeGroups(g)
	-- Criando arquivo de escrita
	local saida = io.open("saida.txt", "w")
	if saida == nil then
		print("Erro ao abrir saida.txt")
		return nil
    end

	-- Imprimindo cada grupo. Somente os identifiicadores são impressos, em ordem cressente e separados por espaços. grupos diferentes são separados por uma linha em branco.
	for i = 1, #(g.groups) do
		if i ~= 1 then
			saida:write("\n\n")
        end
		for j = 1, #(g.groups[i]) do
			if j ~= 1 then
				saida:write(" ")
            end
			saida:write(g.groups[i][j])
		end
    end
    
    io.close(saida)
end

-- Funcão para impressão do arquivo result.txt
-- parâmetros: valor da SSE do agrupamento.
function trabIO.writeSSE(sse)
	-- Criando arquivo de escrita
	local saida = io.open("result.txt", "w")
	if saida == nil then
		print("Erro ao abrir result.txt")
		return nil
    end

	-- Imprimindo a SSE
	saida:write(string.format("%.4f", sse))

    io.close(saida)
end

return trabIO