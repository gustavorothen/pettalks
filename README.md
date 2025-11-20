# pettalks

1. Introdução

O presente documento tem como objetivo apresentar o desenvolvimento do aplicativo PetTalks, criado como protótipo acadêmico para demonstrar o uso de tecnologias móveis modernas. O app consiste em uma rede social lúdica onde usuários podem gravar sons de seus animais de estimação, gerar “traduções” humorísticas e compartilhá-las em um feed interativo.

O projeto permite a exploração de conceitos de desenvolvimento multiplataforma, manipulação de mídia, interação com hardware e construção de interfaces responsivas.

2. Objetivo do Aplicativo

O PetTalks foi projetado com a finalidade de:

Promover uma experiência divertida baseada em gravação de áudio e tradução fictícia.

Permitir que usuários criem perfis personalizados com fotos de seus pets.

Compartilhar postagens no feed contendo texto, imagem e áudio.

Possibilitar interações como curtidas e comentários.

Simular funcionalidades sociais presentes em redes modernas.

Como protótipo acadêmico, não há backend real, e parte dos dados é gerada localmente.

3. Tecnologias Utilizadas
3.1 Flutter

O Flutter foi escolhido como framework principal devido à sua capacidade de gerar aplicações nativas para Android e iOS a partir de um único código-fonte. Ele permite:

Desenvolvimento mais rápido utilizando Hot Reload.

Biblioteca extensa de widgets modernos.

Maior produtividade para prototipagem móvel.

3.2 Linguagem Dart

A lógica da aplicação foi toda implementada na linguagem Dart, que possui sintaxe simples, tipagem estática e integração profunda com o Flutter.

3.3 Plugins e Bibliotecas

record – Utilizado para realizar gravações de áudio usando o microfone do dispositivo.

path_provider – Acesso ao armazenamento interno para salvar áudios e arquivos.

image_picker – Seleção de imagens da galeria do usuário para criação de perfis.

Material Design 3 – Base de componentes visuais, garantindo responsividade e padronização.

Essas bibliotecas são oficiais e distribuídas pelo pub.dev, garantindo segurança e estabilidade.

4. Arquitetura do Projeto

A organização do projeto segue uma estrutura modular para facilitar manutenção e escalabilidade:

lib/features/ – Telas e funcionalidades do app (login, feed, explore, mensagens).

lib/data/models/ – Modelos de dados como User, Pet e Post.

lib/data/mock/ – Dados simulados utilizados para testes.

lib/features/feed/widgets/ – Componentes reutilizáveis.

assets/ – Arquivos de imagem utilizados no layout.

A estrutura foi definida considerando princípios de separação de responsabilidades e clareza na organização do código.

5. Funcionalidades Implementadas
5.1 Cadastro Visual do Usuário

O aplicativo simula um processo de login, permitindo ao usuário informar:

Nome

Nome do pet

Espécie

Foto da galeria

Não há autenticação real — é apenas uma entrada visual para inicializar o perfil.

5.2 Gravação de Áudio

Com o plugin record, o usuário consegue:

Permitir acesso ao microfone

Gravar sons reais

Salvar o áudio em formato .m4a

Gerar automaticamente uma “tradução” humorística

5.3 Publicação no Feed

Cada publicação contém:

Imagem do pet

Tradução gerada

Caminho para o áudio gravado

Data e horário

Botões de curtida e comentário

Interações em tempo real dentro do app

5.4 Sistema de Curtidas e Comentários

A aplicação simula interações sociais:

Curtidas funcionam diretamente no objeto Post

Comentários são registrados de forma visual (mock)

Estados são atualizados dinamicamente

6. Justificativa Acadêmica

O desenvolvimento do PetTalks permite ao estudante:

Compreender na prática o funcionamento de um framework multiplataforma.

Aprender a integrar funcionalidades nativas do dispositivo (microfone, arquivos).

Desenvolver interfaces modernas baseadas em Material Design.

Praticar lógica de programação, organização de componentes e modelos de dados.

Criar um fluxo social completo: cadastro → gravação → publicação → interação.

A construção desse tipo de protótipo é relevante para disciplinas de Desenvolvimento Mobile, Engenharia de Software, Usabilidade e Multimídia.

7. Considerações Finais

O PetTalks se apresenta como um protótipo funcional que demonstra como o Flutter permite desenvolver, de forma rápida e eficiente, aplicações móveis com recursos multimídia e interação social. Sua estrutura modular, uso de plugins e interface moderna o tornam adequado como material de estudo e portfólio acadêmico.
