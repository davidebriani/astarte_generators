#
# This file is part of Astarte.
#
# Copyright 2025 SECO Mind Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

defmodule Astarte.Core.Generators.Value do
  @moduledoc """
  This module provides generators for Astarte values.

  See https://docs.astarte-platform.org/astarte/latest/030-interface.html#supported-data-types
  """
  use ExUnitProperties

  @type value() ::
          String.t() | boolean() | number() | list(String.t()) | list(boolean()) | list(number())
  @type value_type() ::
          :double
          | :integer
          | :boolean
          | :longinteger
          | :string
          | :binaryblob
          | :datetime
          | :doublearray
          | :integerarray
          | :booleanarray
          | :longintegerarray
          | :stringarray
          | :binaryblobarray
          | :datetimearray

  # 64KiB
  @binaryblob_max_bits 64 * 1000 * 8
  @array_max_length 1024

  @doc """
  Generates a valid Astarte value.
  """
  @spec value(value_type()) :: StreamData.t(value())
  def value(:double), do: double_value()
  def value(:integer), do: integer_value()
  def value(:boolean), do: boolean_value()
  def value(:longinteger), do: longinteger_value()
  def value(:string), do: string_value()
  def value(:binaryblob), do: binaryblob_value()
  def value(:datetime), do: datetime_value()
  def value(:doublearray), do: list_of(double_value(), max_length: @array_max_length)
  def value(:integerarray), do: list_of(integer_value(), max_length: @array_max_length)
  def value(:booleanarray), do: list_of(boolean_value(), max_length: @array_max_length)
  def value(:longintegerarray), do: list_of(longinteger_value(), max_length: @array_max_length)
  def value(:stringarray), do: list_of(string_value(), max_length: @array_max_length)
  def value(:binaryblobarray), do: list_of(binaryblob_value(), max_length: @array_max_length)
  def value(:datetimearray), do: list_of(datetime_value(), max_length: @array_max_length)

  defp double_value, do: float()
  defp integer_value, do: integer()
  defp boolean_value, do: boolean()
  defp longinteger_value, do: integer() |> map(&to_string/1)
  defp string_value, do: string(:printable)
  defp binaryblob_value, do: bitstring(max_length: @binaryblob_max_bits) |> map(&Base.encode64/1)
  defp datetime_value, do: repeatedly(fn -> DateTime.utc_now() |> DateTime.to_iso8601() end)
end
