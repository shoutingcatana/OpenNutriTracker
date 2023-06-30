import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:opennutritracker/core/domain/entity/intake_entity.dart';

class IntakeCard extends StatelessWidget {
  final IntakeEntity intake;
  final Function(BuildContext, IntakeEntity) onItemLongPressed;

  const IntakeCard(
      {required Key? key,
      required this.intake,
      required this.onItemLongPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 1,
        child: InkWell(
          onLongPress: () {
            onLongPressedItem(context);
          },
          child: Stack(
            children: [
              intake.product.mainImageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: intake.product.mainImageUrl ?? "",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        )),
                      ),
                    )
                  : Center(
                      child: Icon(Icons.restaurant_outlined,
                          color: Theme.of(context).colorScheme.secondary)),
              Container(
                // Add color shade
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(80),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .tertiaryContainer
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '${intake.totalKcal.toInt()} kcal',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                ),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        intake.product.productName ?? "?",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${intake.amount.toInt().toString()} ${intake.unit}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.8)),
                        maxLines: 1,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void onLongPressedItem(BuildContext context) {
    onItemLongPressed(context, intake);
  }
}
