Link do projeto detalhado: https://ferreiragabrielw.github.io/bike-analytics-case/

1. Contexto e objetivo do trabalho

O objetivo deste case foi consolidar múltiplas fontes de dados relacionadas à operação de um sistema de bicicletas, sendo elas viagens, clientes e assinaturas, faturas e erros operacionais do aplicativo, em uma base única, preparada para análises recorrentes sobre utilização do sistema, desempenho financeiro e qualidade operacional.

2. Ingestão dos dados no BigQuery

As bases fornecidas em formato CSV foram previamente analisadas em Python para uma verificação estrutral rapída, importadas para o Google BigQuery, preservando inicialmente suas características originais. Essa etapa teve como foco garantir a ingestão completa dos dados, respeitando possíveis inconsistências de tipagem e formatação presentes nas fontes.

Para isso, os dados foram carregados na camada Bronze, que representa a zona de dados brutos do pipeline, sem aplicação de regras de negócio ou transformações complexas.

3. Padronização e tratamento dos dados (Camada Silver)

A partir da camada Bronze, foi criada a camada Silver, responsável pela padronização e tratamento dos dados. Nessa etapa foram realizadas as seguintes ações:
- Conversão e padronização de tipos de dados (strings, datas, timestamps e valores numéricos);
- Normalização de identificadores para evitar inconsistências de tipagem;
- Seleção e renomeação de campos para análise;
- Garantia de integridade mínima das tabelas, mantendo a granularidade original de cada fonte.

4. Agregações e modelagem (Camada Gold)

Na camada Gold, os dados foram modelados com foco analítico, respeitando a granularidade adequada de cada entidade:
- Clientes: agregação do histórico de assinaturas para gerar uma visão resumida por cliente;
- Faturas: consolidação das linhas de cobrança em nível de fatura, evitando duplicações financeiras;
- Erros de unlock: agregação dos eventos operacionais por usuário e data;
- Viagens: consolidação final em uma base única, mantendo uma linha por viagem como unidade central de análise.

5. Base final e preparação para ingestão diária

A base final foi criada na tabela gold.viagens_consolidadas, contendo uma linha por viagem e integrando informações operacionais, financeiras e de clientes.

A tabela foi estruturada de forma a permitir ingestões recorrentes, utilizando:
- SQL idempotente (CREATE OR REPLACE);
- Particionamento por data da viagem;
- Separação entre camadas de ingestão, tratamento e consumo;
- Essa abordagem garante escalabilidade e facilidade de manutenção do pipeline.

6. Disponibilização para análise e acompanhamento

Por fim, a base consolidada foi exportada para o Google Sheets, onde foi estruturado um relatório analítico contendo:
- KPIs de utilização, engajamento, financeiro e qualidade operacional, conforme solicitado;
- Estrutura de acompanhamento organizada por tema;
- Documentação do processo e do código SQL utilizado.

