// Copyright (c) 2017, Gerald Leeb. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:mirrors';

class AnnotationUsage<T> {
  LibraryMirror _lib;
  Symbol _symbol;
  List<T> _annotations;

  AnnotationUsage(this._lib, this._symbol, this._annotations);

  List<T> get annotations => _annotations;

  T get singleAnnotation => _annotations.single;

  invoke(List positionalArguments, [Map<Symbol, dynamic> namedArguments]) async {
    await invokeSync(positionalArguments, namedArguments);
  }

  invokeSync(List positionalArguments, [Map<Symbol, dynamic> namedArguments]) {
    _lib.invoke(_symbol, positionalArguments, namedArguments);
  }

  static List<AnnotationUsage/*<T>*/> scanRootLibrary/*<T>*/(/*=T*/Type type) {
    List<AnnotationUsage> usages = [];
    LibraryMirror lib = currentMirrorSystem().isolate.rootLibrary;
    TypeMirror typeMirror = reflectType(type);
    lib.declarations.values.forEach((declaration) {
      List/*<T>*/ annotations = _tryGetAnnotation/*<T>*/(declaration, typeMirror);
      if (annotations.isNotEmpty) {
        usages.add(new AnnotationUsage/*<T>*/(lib, declaration.simpleName, annotations));
      }
    });
    return usages;
  }

  static List/*<T>*/ _tryGetAnnotation/*<T>*/(DeclarationMirror declaration, TypeMirror typeMirror) {
    List/*<T>*/ annotations = [];
    if (declaration is MethodMirror) {
      MethodMirror mm = declaration;
      mm.metadata.forEach((im) {
        var reflectee = im.reflectee;
        if (reflect(reflectee).type == typeMirror) {
          annotations.add(reflectee);
        }
      });
    }
    return annotations;
  }
}

