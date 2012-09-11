Feature: rake license:generate_dependencies
  As a user
  I want a rake task the generates a list of all my application's dependencies and their licenses
  So that I can manually approve a dependency with a non-whitelisted license

  Scenario: Manually approve non-whitelisted dependency
    Given I have a rails application with license finder
    And my rails app depends on a gem "gpl_gem" licensed with "GPL"
    And I whitelist the "MIT" license

    When I run "bundle exec rake license:generate_dependencies"

    Then I should see the following settings for "gpl_gem":
      """
      version: "0.0.0"
      license: "GPL"
      approved: false
      """

    When I update the settings for "gpl_gem" with the following content:
      """
      approved: true
      """

    And I run "bundle exec rake license:action_items"

    Then I should not see "gpl_gem" in its output

  Scenario: Manually adding a javascript dependency to dependencies.yml
    Given I have a rails application with license finder
    When I run "bundle exec rake license:generate_dependencies"
    And I add the following content to "dependencies.yml":
      """
      - name: "my_javascript_library"
        version: "0.0.0"
        license: "GPL"
        approved: false
      """
    And I run "bundle exec rake license:action_items"
    Then I should see "my_javascript_library" in its output

    When I update the settings for "my_javascript_library" with the following content:
      """
      approved: true
      """

    And I run "bundle exec rake license:action_items"
    Then I should not see "my_javascript_library" in its output