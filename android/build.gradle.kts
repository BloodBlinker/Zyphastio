allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    if (project.name == "isar_flutter_libs") {
        project.pluginManager.withPlugin("com.android.library") {
            val android = project.extensions.findByName("android")
            if (android != null) {
                try {
                     val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                     setNamespace.invoke(android, "dev.isar.isar_flutter_libs")
                } catch (e: Exception) {
                    println("Failed to set namespace: $e")
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
