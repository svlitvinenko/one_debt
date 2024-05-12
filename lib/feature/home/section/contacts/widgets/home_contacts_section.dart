import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_debt/core/design/components/ds_card.dart';
import 'package:one_debt/core/design/components/ds_person_rating.dart';
import 'package:one_debt/core/design/theme/theme.dart';
import 'package:one_debt/core/model/d_contact_summary.dart';
import 'package:one_debt/feature/home/section/contacts/bloc/home_contacts_bloc.dart';

class HomeContactsSection extends StatelessWidget {
  final void Function()? onTap;
  const HomeContactsSection({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeContactsBloc()..add(const HomeContactsEvent.initialize()),
      child: DSCard(
        onTap: onTap,
        title: const Text('Contacts'),
        child: LayoutBuilder(builder: (context, constraints) {
          return BlocBuilder<HomeContactsBloc, HomeContactsState>(
            builder: (context, state) {
              return state.map(
                loading: (state) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                loaded: (state) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (_, __) => const SizedBox(width: 32),
                    itemCount: state.contacts.length,
                    itemBuilder: (context, index) {
                      final DContactSummary summary = state.contacts[index];
                      return SizedBox(
                        width: constraints.maxWidth - 32,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Spacer(flex: 3),
                              constraints.maxWidth > 160
                                  ? SizedBox(
                                      width: constraints.smallest.shortestSide * 0.35,
                                      height: constraints.smallest.shortestSide * 0.35,
                                      child: Row(
                                        children: [
                                          AspectRatio(
                                            aspectRatio: 1,
                                            child: Card(
                                              shape: const CircleBorder(),
                                              clipBehavior: Clip.hardEdge,
                                              child: Builder(
                                                builder: (context) {
                                                  final String? url = summary.contact.avatarUrl;
                                                  if (url != null) {
                                                    return Image.network(url);
                                                  } else {
                                                    return Container(
                                                      color: context.colorScheme.primary,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  summary.contact.name,
                                                  style: context.textTheme.titleLarge,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: false,
                                                ),
                                                const Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: DSPersonRating(rating: 4.7),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: constraints.smallest.shortestSide * 0.25,
                                          height: constraints.smallest.shortestSide * 0.25,
                                          child: Card(
                                            shape: const CircleBorder(),
                                            clipBehavior: Clip.hardEdge,
                                            child: Builder(
                                              builder: (context) {
                                                final String? url = summary.contact.avatarUrl;
                                                if (url != null) {
                                                  return Image.network(url);
                                                } else {
                                                  return Container(
                                                    color: context.colorScheme.primary,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          summary.contact.name,
                                          style: context.textTheme.titleLarge,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                        const DSPersonRating(rating: 4.7),
                                      ],
                                    ),
                              const Spacer(flex: 3),
                              if (summary.currentIncoming.cents > 0) ...[
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.call_received_sharp,
                                        color: context.incoming.colorScheme.primary,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          summary.currentIncoming.toString(),
                                          style: context.textTheme.bodyMedium?.copyWith(
                                            color: context.incoming.colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              if (summary.currentOutgoing.cents > 0) ...[
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.call_made_sharp,
                                        color: context.outgoing.colorScheme.primary,
                                        size: 12,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        summary.currentOutgoing.toString(),
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          color: context.outgoing.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const Spacer(flex: 3),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
