package com.example.shared_preferences_plus_android

import android.content.Context
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.robolectric.RobolectricTestRunner
import org.robolectric.RuntimeEnvironment
import org.robolectric.annotation.Config

@RunWith(RobolectricTestRunner::class)
@Config(sdk = [28], manifest = Config.NONE)
class SharedPreferencesPlusApiHandlerTest {
    private lateinit var context: Context
    private lateinit var handler: SharedPreferencesPlusApiHandler
    private val options = SharedPreferencesPlusPigeonOptions("native_contract")

    @Before fun setUp() {
        context = RuntimeEnvironment.getApplication()
        handler = SharedPreferencesPlusApiHandler(context)
        handler.clear(options)
    }

    @Test fun preservesStringsAndListsAfterRecreation() {
        handler.setString("string", "a/0001ub", options)
        val lists = listOf(emptyList(), listOf(""), listOf("only"), listOf("a/0001ub", "", "重复", "重复"))
        lists.forEachIndexed { i, value -> handler.setStringList("list$i", value, options) }
        val recreated = SharedPreferencesPlusApiHandler(context)
        assertEquals("a/0001ub", recreated.getString("string", options))
        assertEquals("a/0001ub", recreated.getAll(options)["string"])
        lists.forEachIndexed { i, value ->
            assertEquals(value, recreated.getStringList("list$i", options))
            assertEquals(value, recreated.getAll(options)["list$i"])
        }
    }

    @Test fun preservesDoublesAndDoesNotCoerceOtherTypes() {
        for (value in listOf(1.0, 1.0000000000000002, -0.0, Double.MAX_VALUE, Double.POSITIVE_INFINITY, Double.NaN)) {
            handler.setDouble("double", value, options)
            val actual = SharedPreferencesPlusApiHandler(context).getDouble("double", options)!!
            assertEquals(value.toBits(), actual.toBits())
            assertTrue(handler.getAll(options)["double"] is Double)
            assertNull(handler.getInt("double", options))
        }
        handler.setInt("int", Long.MAX_VALUE, options)
        assertEquals(Long.MAX_VALUE, handler.getInt("int", options))
        assertNull(handler.getDouble("int", options))
        handler.setBool("bool", true, options)
        assertNull(handler.getInt("bool", options))
    }

    @Test fun readsLegacyValuesWithoutRewritingAmbiguousStrings() {
        val preferences = context.getSharedPreferences(options.name, Context.MODE_PRIVATE)
        preferences.edit().putString("list", "a/0001ub").putString("single", "only")
            .putString("empty", "").putFloat("float", 1.5f).putLong("int", 7).commit()
        assertEquals(listOf("a", "b"), handler.getAll(options)["list"])
        assertEquals("only", handler.getAll(options)["single"])
        assertEquals(listOf("only"), handler.getStringList("single", options))
        assertEquals("", handler.getAll(options)["empty"])
        assertEquals(1.5, handler.getDouble("float", options))
        assertEquals("a/0001ub", preferences.getString("list", null))
    }

    @Test fun isolatesContainersAndSupportsTypeReplacement() {
        val other = SharedPreferencesPlusPigeonOptions("other_contract")
        handler.setStringList("key", listOf("old"), options)
        handler.setInt("key", 42, options)
        handler.setString("key", "other", other)
        assertNull(handler.getStringList("key", options))
        handler.clear(options)
        assertEquals("other", handler.getString("key", other))
        handler.remove("key", other)
        assertFalse(handler.containsKey("key", other))
    }
}
