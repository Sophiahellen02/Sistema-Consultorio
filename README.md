# 🏥 Sistema de Consultório / Clínica — Banco de Dados 

## 👥 Integrantes do Projeto
- Antonio Andson de Oliveira Rocha
- Francisco Thiago da Silva Pinheiro
- Levi Filgueira Chagas
- Luiz Felipe Izidro da Silva
- Sophia Hellen Pires da Silveira

---
## Docente e Disciplina
- Bruno Borges da Silva
- PEX1248 - Banco de Dados - T02 (2025.2 - 2T45 3T23)

---

## 📋 Descrição do Projeto

O **Sistema de Consultório/Clínica** é um projeto completo de modelagem e implementação de banco de dados relacional, desenvolvido para a disciplina de Banco de Dados da UFERSA.

- O sistema gerencia todas as operações essenciais de uma clínica médica, incluindo:
- Cadastro de pacientes e médicos
- Agendamento de consultas
- Registro de atendimentos e prontuários
- Controle financeiro de pagamentos
- Histórico clínico do paciente
- Relatórios usando views, funções e consultas SQL

Regras de negócio foram implementadas com constraints, gatilhos (triggers) e funções PL/pgSQL.

---

## 🎯 Principais Funcionalidades

### Gestão de Pacientes e Médicos
- Cadastro completo
- CPF e CRM únicos
- Data de criação automática

### Gerenciamento de Consultas
- Agendamento com data e horário
- Status (agendada, confirmada, realizada, cancelada)
- Trigger evita conflitos de horário do médico

### Atendimentos e Prontuários
- Notas clínicas
- Receitas e exames solicitados
- Histórico automático via view

### Pagamentos
- Valor, forma e status do pagamento
- Trigger marca consulta como realizada após pagamento confirmado
- Uma consulta → um pagamento

### Relatórios
- Consultas detalhadas
- Histórico de pacientes
- Exames por paciente
- Total pago por paciente
- Consultas realizadas por médico

---

## 🧠 Modelagem do Banco de Dados

- [📘 Modelo Conceitual](Sistema-Consultorio/Diagramas/ModeloConceitual.jpg)   
- [🗂 Modelo Lógico](Sistema-Consultorio/Diagramas/ModeloLógico.jpg) 

---

## 🏗️ Arquitetura do Projeto

```
SISTEMA-CONSULTORIO/
│
├── Diagramas/
│   ├── Modelo_Conceitual.png 
│   └── Modelo_Logico.png
│
├── Doc/
│   └── Sistema de Consultório_Clínica.pdf
│
├── SQL/
│   ├── creates-tables.SQL
│   ├── functions.sql
│   ├── inserts-data.SQL
│   ├── tests.sql
│   └── triggers.sql
│
└── README.md
```

---

## 🛠️ Script SQL

### 📌 1. Criação de Tabelas — `creates-tables.SQL`
- Criação do banco
- Tabelas e relações
- Constraints (PK, FK, UNIQUE)
- Views de apoio

### 📌 2. Inserção de Dados — `inserts-data.SQL`
- Dados iniciais
- Atualizações e correções
- Remoções com restrições
- Consultas exploratórias

### 📌 3. Funções — `functions.sql`
- `fn_total_pago_paciente(id)`
- `fn_consultas_realizadas_medico(id)`

### 📌 4. Triggers — `triggers.sql`
- `trg_validar_horario_medico`
- `trg_atualizar_status_consulta`

### 📌 5. Testes — `tests.sql`
- Inserções inválidas
- Constraints
- Views
- Funções
- Triggers

---

## Documentação Completa (PDF)

### Documentação oficial com:
- Requisitos
- Casos de Uso
- Normalização
- Modelagem
- Dicionário de dados
- Plano de testes

[📝 Link para a documentação](Doc\SistemadeConsultório_Clínica.pdf)   

---

## ▶️ Guia de Uso (pgAdmin 4)

### 1. Criar o banco

No pgAdmin:
- Clique com o botão direito em **Databases**
- Selecione **Create > Database**...
- Nomeie como: **clinica_bd**
- Clique em **Save**

Ou, se preferir usar a Query Tool:
```powershell
CREATE DATABASE clinica_bd;
```

### 2. Conectar-se ao Banco e Abrir a Query Tool
- Expanda **Databases** > **clinica_bd**
- Clique com o botão direito em **clinica_bd**
- Selecione **Query Tool**

### 3. Executar a Criação das Tabelas

Na Query Tool, carregue **creates-tables.SQL**:
- Vá em **File** > **Open File**
- Selecione o arquivo:
```powershell
SQL/creates-tables.SQL
```
- Clique em **Execute (F5)**

### 4. Iserir Dados Inicias

Abra o arquivo:
```powershell
SQL/inserts-data.SQL
```
Execute (F5).

### 5. Ative Funções e Triggers

Abra:
```powershell
SQL/functions.sql
```
Execute (F5).

Depois:
```powershell
SQL/triggers.sql
```
Execute novamente (F5).

### 6. Executar os Testes

Abra:
```powershell
SQL/tests.sql
```
e execute (F5) para validar:
- Inserts
- Views
- Funções
- Gatilhos
- Constraints

### 7. Visualizar as Tabelas, Views e Dados

No pgAdmin:
- Expanda **Schemas** > **public** > **Tables** para ver as tabelas
- Expanda **Views** para ver as views criadas
- Clique com o botão direito > *Views/Edit Data para consultar os dados

### 8. Possíveis Ajustes
Caso já exista uma tabela e o script tente criá-la novamente, use:
- Drop Table
- Ou ajuste o script antes de rodar

---

## 🧩 Regras de Negócio Implementadas
- Médico não pode ter duas consultas no mesmo horário
- Pagamento aprovado → consulta com status realizada
- Consulta só pode ter um prontuário
- Consulta só pode ter um pagamento
- Integridade referencial garantida em todas as entidades
- Histórico automatizado via views

---

## 🎓 Conceitos de Banco de Dados Aplicados
- Modelagem Conceitual, Lógica e Física
- Normalização (1FN, 2FN, 3FN)
- Integridade referencial (PK, FK)
- Constraints avançadas
- Views
- Triggers
- Funções armazenadas
- Testes sistemáticos

---

## 📝 Licença
Projeto desenvolvido exclusivamente para fins educacionais.
