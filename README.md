# annotationscanner

Scans root library for annotation usages.

## Usage

A simple usage example:

    import 'package:annotationscanner/annotationscanner.dart';

    @MyAnnotationA(1)
    void myMethodA() {
      print("myMethodA");
    }
    
    @MyAnnotationA(2)
    void myMethodB() {
      print("myMethodB");
    }
    
    @MyAnnotationA(3)
    @MyAnnotationB('one')
    void myMethodC() {
      print("myMethodC");
    }
    
    @MyAnnotationB('two')
    @MyAnnotationB('three')
    void myMethodD() {
      print("myMethodD");
    }
    
    void myMethodE() {
      print("myMethodE");
    }
    
    
    main() {
      List<AnnotationUsage<MyAnnotationA>> scanA = AnnotationUsage.scanRootLibrary(MyAnnotationA);
      scanA.forEach((usage) {
        print(usage.singleAnnotation.valueA);
        usage.invoke([]);
      });
      List<AnnotationUsage<MyAnnotationB>> scanB = AnnotationUsage.scanRootLibrary(MyAnnotationB);
      scanB.forEach((usage) {
        print(usage.annotations);
        usage.invokeSync([]);
      });
    }
    
    
    class MyAnnotationA {
      final int valueA;
    
      const MyAnnotationA([this.valueA]);
    }
    
    class MyAnnotationB {
      final String valueB;
    
      const MyAnnotationB([this.valueB]);
    }

