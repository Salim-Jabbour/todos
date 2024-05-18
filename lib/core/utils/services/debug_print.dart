import 'dart:developer';

void dbg(Object? o) {
  log(
    o?.toString()??'null',
  );
}