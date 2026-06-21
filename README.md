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
