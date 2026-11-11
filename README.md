# GAME_OF_SHIFT
rojeto em desenvolvimento para submissão à Game Off 2026 Game Jam. Desenvolvido com o objetivo de participar do evento e explorar novas ideias e mecânicas de gameplay.

## Organização dos recursos

O Navegador de Recursos do GameMaker está dividido em quatro pastas principais:

- `Plataforma`: objetos, salas e sprites desse gênero. Os sprites ficam separados
  em `Jogador`, `Cenario`, `Efeitos` e `Placeholders`.
- `TopDown`: objetos, salas, scripts, sprites e tilesets desse gênero. Os sprites
  ficam separados em `Jogador`, `Cenario` e `Tiles`.
- `Spaceship`: objetos, salas e sprites do jogo de navinha.
- `Compartilhado`: controles e efeitos genéricos, scripts reutilizados,
  `Interface`, `Menu` e `Testes`. Interface reúne os painéis, diálogos, cursores,
  fontes e a sala de teste de janelas. Menu reúne os atalhos dos três gêneros.

Coloque novos recursos exclusivos na pasta do gênero correspondente. Recursos
usados por mais de um gênero ficam em `Compartilhado`. As pastas físicas seguem
o padrão do GameMaker (`objects`, `sprites`, `scripts`, `rooms` etc.).

## Criando atalhos de menu

`obj_shortcut` concentra o desenho, o destaque do mouse e o clique com transição
de sala. `obj_plataformer_shotcut` é um exemplo de filho.

Para criar outro atalho:

1. Crie um objeto com `obj_shortcut` como pai e escolha o sprite no editor.
2. Adicione somente o evento Create com as configurações do novo atalho:

```gml
event_inherited();
text = "Top Down";
target_room = Rm_TopDownTest;
```

Após `event_inherited()`, também é possível ajustar `text_gap`, `text_font`,
`text_color`, `hover_enabled`, `hover_color`, `hover_alpha` e `hover_padding`.
Os eventos Draw e End Step são herdados; não é necessário copiá-los.
Coloque o filho na sala do menu. O cursor reconhece todos os filhos automaticamente.
Sem uma sala de destino válida, o clique não inicia a transição.

## Base de painéis

Coloque uma instância de `obj_panel_control` e quantas instâncias de `obj_panel`
precisar na sala. Configure `index` nas Definições de Variáveis de cada painel
(inteiro, padrão `0`). Painéis com o mesmo índice recebem a mesma regra.

O controlador usa `with (obj_panel)` e `switch (index)` nos eventos Step e Draw.
Adicione os casos de cada índice no evento que precisar; dentro do `with`,
as variáveis são do painel e `other` referencia o controlador. Para outro evento,
use a mesma estrutura no `obj_panel_control`. Os casos estão vazios por enquanto,
sem lógica ou desenho. Os objetos ainda não foram colocados em nenhuma sala.

## License

The source code is licensed under the MIT License.

All original game assets, including sprites, artwork, music and sound effects, are proprietary and may not be used commercially without prior written permission from the author.

Third-party assets remain the property of their respective owners.
