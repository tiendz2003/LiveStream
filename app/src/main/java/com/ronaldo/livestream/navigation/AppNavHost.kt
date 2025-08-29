package com.ronaldo.livestream.navigation

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.rememberNavController
import com.ronaldo.livestream.feature.home.homeScreen
import com.ronaldo.livestream.feature.home.navigateToHome
import com.ronaldo.livestream.feature.login.Login
import com.ronaldo.livestream.feature.login.loginScreen
import kotlin.reflect.KClass

@Composable
fun AppNavHost(
    modifier: Modifier = Modifier,
    startDestination: KClass<*> = Login::class
) {
    val navController = rememberNavController()
    NavHost(
        modifier = modifier,
        navController = navController,
        startDestination = startDestination
    ) {
        homeScreen()
        loginScreen(navigateToHome = navController::navigateToHome)
    }
}
