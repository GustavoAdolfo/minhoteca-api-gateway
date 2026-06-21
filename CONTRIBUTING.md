# Contribuindo com o minhoteca-api-gateway

Obrigado por contribuir! Este guia cobre tudo que você precisa para colaborar com o repositório de API Gateway do projeto Minhoteca.

## Índice

- [Pré-requisitos](#pré-requisitos)
- [Configurando o ambiente](#configurando-o-ambiente)
- [Fluxo de trabalho](#fluxo-de-trabalho)
- [Convenção de commits](#convenção-de-commits)
- [Padrões de código Terraform](#padrões-de-código-terraform)
- [Abrindo um Pull Request](#abrindo-um-pull-request)
- [Reportando bugs](#reportando-bugs)
- [Sugerindo melhorias](#sugerindo-melhorias)

---

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.x
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- [tflint](https://github.com/terraform-linters/tflint) (recomendado para lint local)
- [terraform-docs](https://terraform-docs.io/) (opcional)
- Credenciais AWS com permissões para API Gateway, IAM e CloudWatch

---

## Configurando o ambiente

1. Faça um fork do repositório e clone localmente:

```bash
git clone https://github.com/<seu-usuario>/minhoteca-api-gateway.git
cd minhoteca-api-gateway
```

2. Inicialize e valide o Terraform (assim que os arquivos de infraestrutura estiverem disponíveis):

```bash
terraform init
terraform validate
terraform fmt -check -recursive
```

3. Gere o plano para revisar alterações:

```bash
terraform plan -out plan.tfplan
```

---

## Fluxo de trabalho

Usamos o modelo de branches com `main` e `develop`:

| Branch         | Propósito                                   |
| -------------- | ------------------------------------------- |
| `main`         | Código estável em produção                  |
| `develop`      | Integração de novas features                |
| `feat/<nome>`  | Nova feature de infraestrutura              |
| `fix/<nome>`   | Correção de bug ou configuração             |
| `chore/<nome>` | Tarefas de manutenção sem impacto funcional |

1. Crie sua branch a partir de `develop`:

```bash
git checkout develop
git pull origin develop
git checkout -b feat/nome-da-feature
```

2. Faça as alterações e valide localmente.
3. Abra um PR para `develop`.

---

## Convenção de commits

Seguimos o padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/):

```
<tipo>(escopo opcional): descrição curta
```

### Tipos aceitos

| Tipo       | Quando usar                                     |
| ---------- | ----------------------------------------------- |
| `feat`     | Novo recurso de API Gateway ou módulo Terraform |
| `fix`      | Correção de comportamento ou configuração       |
| `docs`     | Alterações em documentação                      |
| `chore`    | Atualização de dependências e manutenção        |
| `refactor` | Refatoração sem mudança de comportamento        |
| `ci`       | Alterações no pipeline de CI/CD                 |

### Exemplos

```
feat(apigateway): adiciona rota de empréstimos
fix(stage): corrige variável de ambiente no stage dev
docs: atualiza instruções de execução local
ci: adiciona validação terraform fmt no workflow
```

---

## Padrões de código Terraform

- Formate o código antes de commitar:

```bash
terraform fmt -recursive
```

- Garanta validação sem erros:

```bash
terraform validate
```

- Sempre que possível:
  - Use variáveis para evitar hardcode de valores
  - Use outputs para expor informações relevantes entre módulos
  - Use nomes de recursos previsíveis e padronizados
  - Evite colocar dados sensíveis em código

---

## Abrindo um Pull Request

1. Certifique-se de que `terraform validate` e `terraform fmt -check -recursive` passam sem erros.
2. Descreva no PR:
   - O que foi alterado
   - Impacto esperado na infraestrutura
   - Eventuais dependências entre módulos/recursos
3. Prefira PRs pequenos e objetivos para facilitar revisão.
4. Pelo menos uma aprovação é necessária antes do merge.

---

## Reportando bugs

Abra uma [Issue](https://github.com/GustavoAdolfo/minhoteca-api-gateway/issues) com:

- Descrição do comportamento inesperado
- Ambiente afetado (`dev`, `prod`, etc.)
- Saída relevante dos comandos Terraform (`plan`, `apply` ou erro)
- Versão do Terraform utilizada

---

## Sugerindo melhorias

Abra uma [Issue](https://github.com/GustavoAdolfo/minhoteca-api-gateway/issues) com o label `enhancement` descrevendo:

- O recurso que deseja adicionar
- Justificativa e caso de uso
- Referências relevantes (AWS/Terraform)

---

Contribuições em qualquer nível são bem-vindas. Obrigado por ajudar a evoluir a infraestrutura da Minhoteca! 📚
