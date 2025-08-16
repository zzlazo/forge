import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/router/router.dart';
import '../../../../shared/application/application_exception.dart';
import '../../../../shared/presentation/async_state_builder/shared_async_state_builder.dart';
import '../../../../shared/presentation/base_screen/shared_app_bar.dart';
import '../../../../shared/presentation/base_screen/shared_base_screen.dart';
import '../../../../shared/presentation/widget_title/shared_widget_title.dart';
import '../../../../shared/provider/shared_provider.dart';
import '../../application/provider/deck_management_provider.dart';
import '../../model/deck_model/deck_model.dart';
import 'export_deck_utility.dart';

const Size exportCardSize = Size(300, 600);

class ExportDeckScreen extends ConsumerWidget {
  const ExportDeckScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(exportDeckKeepAliveProvider);
    ref.listen(exportDeckImageNotifierProvider, (previous, next) {
      if (next.isLoading && previous?.isLoading != true) {
        context.push(SaveDeckImageRoute().location);
      } else if (next.hasValue && previous?.isLoading == true) {
        context.pop();
      } else if (next.hasError && next.error is ApplicationException) {
        ref
            .read(applicationExceptionStateNotifierProvider.notifier)
            .notify(next.error! as ApplicationException);
      }
    });
    final List<CardData> cards = ref.watch(
      getDeckDataProvider.select((e) => e.valueOrNull?.cards ?? []),
    );
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return SharedBaseScreen(
      appBar: SharedAppBar(
        title: "Preview Deck",
        actions: [
          IconButton(
            onPressed: () async {
              await ExportDeckConfigRoute().push(context);
            },
            icon: Icon(Icons.palette),
          ),
          IconButton(
            onPressed: () async {
              await ref
                  .read(exportDeckImageNotifierProvider.notifier)
                  .export(
                    cards: renderCards(
                      context,
                      cards,
                      ref.read(cardPainterStateNotifierProvider),
                    ),
                    pixelRatio: pixelRatio,
                  );
            },
            icon: Icon(Icons.download),
          ),
        ],
      ),
      body: SharedAsyncStateBuilder(
        asyncValue: ref.watch(getDeckDataProvider),
        builder: (value) => _ExportDeckScreenContent(cards: cards),
      ),
    );
  }

  Map<String, Widget> renderCards(
    BuildContext context,
    List<CardData> cards,
    CardPainterState state,
  ) {
    return Map.fromEntries(
      cards.map(
        (e) => MapEntry(
          ExportDeckUtility.getDeckTitle(e.index?.suit, e.index?.number),
          renderCardWidget(context, e, state),
        ),
      ),
    );
  }

  Widget renderCardWidget(
    BuildContext context,
    CardData card,
    CardPainterState state,
  ) {
    return Material(
      child: Directionality(
        textDirection: Directionality.of(context),
        child: MediaQuery(
          data: MediaQuery.of(context),
          child: Theme(
            data: Theme.of(context),
            child: ExportDeckListItem(
              key: ValueKey(
                'export_card_${card.index?.suit}${card.index?.number}',
              ),
              config: CardPainterItemConfig(
                text: card.text ?? "",
                suit: card.index?.suit,
                number: card.index?.number,
                textStyle: Theme.of(context).textTheme.titleLarge,
                indexStyle: Theme.of(context).textTheme.titleLarge,
                state: state,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportDeckScreenContent extends ConsumerWidget {
  const _ExportDeckScreenContent({
    // ignore: unused_element_parameter
    super.key,
    required this.cards,
  });

  final List<CardData> cards;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              SharedWidgetTitle(title: "Cards"),
              Expanded(
                child: _ExportDeckListView(
                  cards: cards,
                  stateProvider: cardPainterStateNotifierProvider,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ExportDeckListView extends ConsumerWidget {
  const _ExportDeckListView({
    // ignore: unused_element_parameter
    super.key,
    required this.cards,
    required this.stateProvider,
  });

  final List<CardData> cards;
  final ProviderListenable<CardPainterState> stateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final CardData card = cards[index];

        return Center(
          child: ExportDeckListItem(
            config: CardPainterItemConfig(
              text: card.text ?? "",
              suit: card.index?.suit,
              number: card.index?.number,
              textStyle: Theme.of(context).textTheme.bodyLarge,
              indexStyle: Theme.of(context).textTheme.titleLarge,
              state: ref.watch(stateProvider),
            ),
          ),
        );
      },
    );
  }
}

class ExportDeckListItem extends ConsumerWidget {
  const ExportDeckListItem({
    // ignore: unused_element_parameter
    super.key,
    required this.config,
  });

  final CardPainterItemConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      size: Size(300, 600),
      painter: _CardPainter(config: config),
    );
  }
}

class _CardPainter extends CustomPainter {
  final CardPainterItemConfig config;

  _CardPainter({required this.config});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = config.state.backGroundColor
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawRect(rect, paint);

    final String suitSymbol = PlayingCardDatas.suitSymbols[config.suit] ?? "";
    final String numberSymbol =
        PlayingCardDatas.numberSymbols[config.number] ?? "";

    final indexPainter = TextPainter(
      text: TextSpan(
        text: "$suitSymbol$numberSymbol",
        style: config.indexStyle?.copyWith(color: config.state.textColor),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: config.text,
        style: config.textStyle?.copyWith(color: config.state.textColor),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    indexPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final indexOffset = Offset((size.width - indexPainter.width) / 2, 10);
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      indexPainter.height + indexOffset.dy + 10,
    );

    indexPainter.paint(canvas, indexOffset);

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant _CardPainter oldDelegate) {
    return oldDelegate.config != config;
  }
}
