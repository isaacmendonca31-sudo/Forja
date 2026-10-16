# Configurar contas e sincronização do FORJA

O FORJA usa Supabase Auth para e-mail/senha e uma tabela PostgreSQL com Row Level Security (RLS) para manter os dados privados por usuário. A configuração abaixo é necessária antes que cadastro, login e nuvem funcionem. Sem essas credenciais, o app continua funcionando no modo local/offline.

## 1. Criar o projeto Supabase

1. Crie um projeto em https://supabase.com/.
2. Guarde a senha do banco em um gerenciador de senhas; ela não é necessária no frontend.
3. No painel do projeto, abra **Project Settings → API** (o nome da seção pode variar).
4. Copie a **Project URL** e a chave pública **publishable** ou a chave legada **anon**.
5. Nunca use a `service_role` ou uma chave `secret` no aplicativo. A chave pública só é adequada no frontend porque as políticas RLS restringem o acesso.

## 2. Criar a tabela segura

1. Abra **SQL Editor** no painel do Supabase.
2. Abra o arquivo `supabase-schema.sql` que acompanha o FORJA.
3. Execute o SQL completo.
4. Confirme que `public.forja_user_data` existe e que RLS está habilitado.

A tabela guarda uma linha por conta. As políticas verificam `auth.uid() = user_id`, de modo que uma conta não pode consultar ou alterar a linha de outra conta.

## 3. Configurar o frontend

Edite `supabase-config.js` e substitua os dois valores de exemplo:

```js
window.FORJA_SUPABASE_CONFIG = {
  url: 'https://SEU-PROJETO.supabase.co',
  anonKey: 'SUA-CHAVE-PUBLICA-ANON-OU-PUBLISHABLE'
};
```

O arquivo será público no GitHub Pages. Isso é esperado para a URL e a chave publishable/anon. **Não adicione senhas, `service_role`, chaves secretas ou credenciais administrativas.** A segurança depende das políticas RLS no banco.

## 4. Configurar autenticação por e-mail

No painel Supabase, em **Authentication → URL Configuration**:

- Configure **Site URL** com a URL base publicada do FORJA.
- Adicione a URL completa do app em **Redirect URLs**, incluindo o caminho do repositório do GitHub Pages, se houver.
- Em **Authentication → Providers → Email**, mantenha e-mail/senha habilitado.
- A confirmação de e-mail pode ficar habilitada. Nesse caso, o usuário precisa abrir o e-mail recebido antes de entrar.
- Para que e-mails de confirmação e recuperação cheguem de forma confiável, configure um provedor SMTP personalizado no Supabase se necessário; o serviço padrão pode ter limitações.

O botão “Esqueci minha senha” usa a URL atual do app como destino de retorno. Confira também os modelos de e-mail no painel.

## 5. Publicar e testar

1. Envie todos os arquivos da pasta `treino-pwa` para o repositório publicado, incluindo `supabase-config.js` e `supabase-schema.sql`.
2. Publique em HTTPS pelo GitHub Pages.
3. Abra o app online e crie uma conta com e-mail e senha.
4. Confirme o e-mail, se solicitado, e entre.
5. Faça um treino de teste, aguarde a sincronização e abra o FORJA em outro navegador/dispositivo para confirmar que os registros aparecem após entrar na mesma conta.
6. Crie uma segunda conta e confirme que ela não consegue ver os dados da primeira.
7. Desative a conexão, registre uma série e reconecte. A sincronização deve ser tentada automaticamente quando a conexão voltar.
8. Teste exportar um backup antes de limpar dados ou trocar de navegador.

## Como funciona a sincronização

- Os registros são salvos primeiro no armazenamento local para que o treino continue disponível offline.
- Quando há conta conectada e rede, o app combina registros de treino por ID e mantém a versão mais recente em caso de IDs coincidentes.
- A sessão em andamento tem um marcador de atualização para que o encerramento da sessão não seja confundido com uma sessão antiga na nuvem.
- Exclusões são registradas como marcadores, para que um treino removido não reapareça ao sincronizar outro dispositivo.
- Ao entrar pela primeira vez em um navegador com dados legados, o app pergunta se deseja importá-los para a conta. O armazenamento local original não é apagado por essa importação.
- A sincronização atual usa uma linha JSONB por conta. É adequada para a primeira versão, mas um futuro uso intensivo pode justificar separar treinos em linhas individuais e adicionar testes automatizados de conflito.

## Limitações importantes

- A conta e a sincronização não funcionam até que você crie o projeto Supabase, execute o SQL e configure `supabase-config.js`.
- O aplicativo continua registrando localmente sem internet. Login, cadastro e sincronização precisam de conexão.
- Não foi possível testar o acesso real ao banco sem credenciais de um projeto Supabase. Antes de uso real, valide as políticas RLS com duas contas diferentes e teste recuperação de senha.
