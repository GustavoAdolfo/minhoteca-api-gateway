![GitHub](https://img.shields.io/github/license/GustavoAdolfo/minhoteca-api-gateway)

# minhoteca-api-gateway

Infraestrutura do API Gateway da Minhoteca, gerenciada com Terraform.

## 🎯 Propósito Social

Minhoteca tem como missão facilitar o acesso gratuito à leitura, gestão de empréstimos e organização de pequenas bibliotecas em comunidades, ONGs e projetos sociais, contribuindo para os Objetivos de Desenvolvimento Sustentável (ODS) da ONU.

**Alinhamento aos ODS:**

- 🎓 ODS 4: Educação de Qualidade
- 📚 ODS 10: Redução das Desigualdades
- 💚 ODS 17: Parcerias para a Implementação dos Objetivos

## Visão geral

Este repositório centraliza a definição de infraestrutura do API Gateway da Minhoteca em AWS com Terraform, incluindo rotas, integrações, estágios e políticas necessárias para exposição segura das APIs.

No momento, o projeto está em fase inicial de estruturação e documentação.

### Termos de uso

`GET /v1/termos-de-uso` retorna diretamente o corpo de
`s3://minhoteca-contratos/termos-de-uso.md`, com
`Content-Type: text/markdown; charset=utf-8`. Não usa Lambda nem authorizer;
exige `x-api-key`. O OPTIONS é público.

A integração usa uma role dedicada com `s3:GetObject` somente para esse arquivo
e `kms:Decrypt` na chave Minhoteca, via S3. O alias da chave é configurado por
`kms_minhoteca_alias_name` (padrão: `alias/minhoteca_log_encrypt`).
O bucket e a chave devem existir na mesma região da API antes do deploy.
O arquivo deve estar publicado em UTF-8; o Terraform não envia seu conteúdo.

A leitura seleciona a versão atual do objeto. Erros S3 403 e 404 são preservados;
demais respostas inesperadas retornam 502, nunca sucesso com XML de erro.
Sem `s3:ListBucket`, o S3 pode responder 403 para um objeto inexistente.

### Rotas administrativas de usuários e listas

| Método | Rota |
| ------ | ---- |
| GET | `/v1/admin/usuarios` |
| GET | `/v1/admin/usuario/{id}` |
| GET | `/v1/admin/lista/{tipo}` |
| POST | `/v1/admin/lista` |
| PUT | `/v1/admin/lista/{tipo}/{idUsuario}` |

As rotas usam o authorizer Cognito existente e exigem API key, assim como as
demais rotas administrativas. Todas usam integração `AWS_PROXY` com
`lambda_admin_invoke_arn`, associado à função administrativa em produção.
Os parâmetros de caminho são enviados à Lambda sem renomeação.
Cada recurso possui OPTIONS público para preflight CORS. As novas integrações
participam do gatilho e das dependências do deployment da API.

Os testes de contrato das novas rotas usam providers simulados, sem criar
recursos AWS (Terraform >= 1.7):

```bash
terraform -chdir=modules/gateway init -backend=false
terraform -chdir=modules/gateway test
```

### Principais arquivos

- `README.md` - documentação principal do projeto
- `CHANGELOG.md` - histórico de mudanças
- `CONTRIBUTING.md` - guia de contribuição
- `LICENSE` - licença de uso

## Estrutura atual

```
CHANGELOG.md
CONTRIBUTING.md
LICENSE
README.md
```

## Pré-requisitos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.x
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Credenciais AWS com permissões para API Gateway, IAM e CloudWatch

## Como executar localmente

Quando os arquivos Terraform de ambientes estiverem disponíveis, o fluxo padrão será:

1. Inicializar o Terraform:

```bash
terraform init
```

2. Validar a configuração:

```bash
terraform validate
terraform fmt -check -recursive
```

3. Gerar o plano:

```bash
terraform plan -out plan.tfplan
```

4. Aplicar as mudanças:

```bash
terraform apply plan.tfplan
```

## Objetivo técnico do repositório

- Publicar e versionar API Gateway via Terraform
- Padronizar rotas, estágios e integrações de backend
- Garantir reprodutibilidade da infraestrutura entre ambientes
- Facilitar auditoria e evolução contínua da camada de entrada da plataforma

## 🤝 Contribuir

Quer contribuir? Consulte [CONTRIBUTING.md](./CONTRIBUTING.md) para padrões de código, convenção de commits e fluxo de PR.

Contribuições em qualquer nível são bem-vindas:

- 🐛 Reportar bugs
- 📝 Melhorar documentação
- ✨ Sugerir melhorias
- 🔧 Submeter PRs

## 📋 Roadmap

**v0.2.0** (Próximo):

- [ ] Estruturar ambientes Terraform (`dev` e `prod`)
- [ ] Provisionar API HTTP/API REST no API Gateway
- [ ] Definir integração inicial com Lambda
- [ ] Publicar pipeline de validação Terraform no CI

**v0.3.0**:

- [ ] Configurar domínio customizado e mapeamento de base path
- [ ] Adicionar observabilidade (logs/métricas)
- [ ] Aplicar políticas de segurança e rate limiting

## 📄 Licença

Distribuído sob licença **MIT** (veja [LICENSE](./LICENSE)).

## 🔗 Links

- [GitHub](https://github.com/GustavoAdolfo/minhoteca-api-gateway)
- [Issues](https://github.com/GustavoAdolfo/minhoteca-api-gateway/issues)

## 💬 Suporte

- 🐛 Abra uma [Issue](https://github.com/GustavoAdolfo/minhoteca-api-gateway/issues)

---

**Minhoteca é código aberto e feito com ❤️ para a comunidade.**
