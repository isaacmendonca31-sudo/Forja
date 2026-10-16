# FORJA — PWA de registro de treinos

Aplicativo em HTML, CSS e JavaScript. A versão 0.5.0 adiciona autenticação por e-mail/senha e sincronização opcional com Supabase; o modo local/offline continua disponível.

## Recursos desta versão 0.5.0
- Ficha inicial de cinco dias baseada no plano combinado.
- Registro individual de peso, repetições e conclusão de cada série.
- Exibição do último desempenho registrado em cada exercício durante a sessão.
- Temporizador de descanso com iniciar, pausar, retomar e zerar.
- Remoção da última série adicionada, com confirmação quando ela já foi concluída.
- Possibilidade de adicionar séries.
- Notas por treino e histórico com detalhes.
- Exportação e importação de backup JSON.
- Base pesquisável de exercícios por grupo muscular, equipamento e tipo, com alternativas mais próximas do padrão de movimento.
- Filtros independentes por grupo muscular, equipamento e tipo de exercício.
- Gráfico de volume por sessão para acompanhar até seis registros recentes de um exercício.
- Sugestões locais baseadas no histórico: progressão de carga e revisão de possíveis platôs usando exposições comparáveis. Sugestões podem ser dispensadas e não alteram automaticamente a ficha.
- Backup inclui registros e sessão em andamento; importação valida a estrutura e combina registros sem duplicar IDs.
- Tratamento de falhas no armazenamento local e atualização de cache PWA com versão nova.
- Manifesto PWA, service worker e layout responsivo para celular.
- Cadastro, login, recuperação de senha e saída usando Supabase Auth.
- Sincronização automática de treinos, sessão em andamento e sugestões dispensadas quando a conta está conectada e há internet.
- Armazenamento local separado por conta no mesmo navegador, com opção de migrar os registros legados após confirmação.
- SQL de tabela e políticas RLS para que cada usuário acesse somente seus dados.
- Arquivo `supabase-config.js` com placeholders públicos, sem credenciais secretas.

## Configurar contas e nuvem
1. Siga o guia `SUPABASE_SETUP.md`.
2. Crie um projeto Supabase e execute `supabase-schema.sql` no SQL Editor.
3. Preencha `supabase-config.js` com a Project URL e a chave pública `publishable`/`anon`. Nunca use `service_role` ou chave secreta no frontend.
4. Configure a URL do GitHub Pages em Authentication → URL Configuration no Supabase.
5. Sem essa configuração, o app permanece em modo local e offline; cadastro e sincronização não funcionam.

## Rodar localmente
1. Extraia a pasta e abra-a no VS Code.
2. Instale a extensão **Live Server** (ou use outro servidor local).
3. Clique com o botão direito em `index.html` e escolha **Open with Live Server**.
4. No celular, para instalar como PWA, publique em HTTPS. `file://` não permite service worker.

## Publicar com GitHub Pages
1. Coloque os arquivos desta pasta na raiz do repositório (ou na pasta configurada em Pages).
2. Em GitHub → Settings → Pages, escolha a branch e a pasta correta.
3. Aguarde a publicação e abra o endereço HTTPS no navegador do celular.
4. Android/Chrome: menu ⋮ → **Instalar app** ou **Adicionar à tela inicial**. No iPhone, Safari → Compartilhar → **Adicionar à Tela de Início**.

## Importante sobre os dados
- Sem uma conta conectada e configurada, o armazenamento é local a este navegador e dispositivo.
- Com Supabase configurado, o app salva primeiro localmente e sincroniza quando a conta está conectada e há rede.
- Exporte backups regularmente. Limpar os dados do navegador pode apagar os registros locais.
- O service worker pode manter uma versão em cache; após alterações, aumente a versão de `CACHE_NAME` em `sw.js`.
- O SQL habilita RLS e restringe cada linha ao UID autenticado. Valide com duas contas antes de considerar o serviço pronto para produção.
