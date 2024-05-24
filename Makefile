local:
	scala-cli publish local X10Toolkit.scala publish-conf.scala
	scala-cli publish local X10ToolkitTest.scala publish-conf.scala

	scala-cli publish local X10NativeToolkit.scala publish-conf.scala
	scala-cli publish local X10NativeToolkitTest.scala publish-conf.scala

	scala-cli publish local --native X10NativeToolkit.scala X10NativeToolkit.native.scala publish-conf.scala
	scala-cli publish local --native X10NativeToolkitTest.scala publish-conf.scala
