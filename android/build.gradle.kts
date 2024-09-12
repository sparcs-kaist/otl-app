import com.android.build.gradle.BaseExtension
import com.android.build.gradle.LibraryExtension
import com.android.build.gradle.internal.dsl.BaseAppModuleExtension
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

buildscript {
    extra.apply {
        set("compileSdkVersion", 34)
        set("targetSdkVersion", 34)
    }
    repositories {
        maven {
            url = uri("https://plugins.gradle.org/m2/")
        }
    }
    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.23")
    }
}

rootProject.layout.buildDirectory.set(file("../build"))
subprojects {
    project.layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.asFile.get().path}/${project.name}"))
}
subprojects {
    // check if library extension block is available and namespace isn't set
    afterEvaluate {
        if (project.hasProperty("android")) {
            val ext = try {
                project.extensions.getByType<BaseAppModuleExtension>()
            } catch (_: Exception) {
                project.extensions.getByType<LibraryExtension>()
            }

            ext.apply {
                if (namespace == null) {
                    namespace = project.group.toString()
                }
            }
        }
        if (project.plugins.hasPlugin("com.android.application") ||
            project.plugins.hasPlugin("com.android.library")
        ) {
            project.extensions.configure<BaseExtension> {
                rootProject.extra.get("compileSdkVersion")?.toString()?.toIntOrNull()?.let { compileSdkVersion(it) }
            }
        }
        tasks.withType(KotlinCompile::class.java).configureEach {
            if (project.plugins.hasPlugin("com.android.application") || project.plugins.hasPlugin("com.android.library")) {
                kotlinOptions {
                    kotlinOptions.jvmTarget =
                        project.extensions.getByType<BaseExtension>().compileOptions.sourceCompatibility.toString()
                }
            }
        }
    }

    project.evaluationDependsOn(":app")
}

tasks {
    register<Delete>("clean") {
        delete(rootProject.layout.buildDirectory)
    }
}
